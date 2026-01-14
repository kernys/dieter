import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/constants/app_constants.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

class FoodAnalysisResult {
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<IngredientAnalysis> ingredients;

  FoodAnalysisResult({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
  });

  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    return FoodAnalysisResult(
      name: json['name'] as String? ?? 'Unknown Food',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientAnalysis.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
      };
}

class IngredientAnalysis {
  final String name;
  final String? amount;
  final int calories;
  final double? protein;
  final double? carbs;
  final double? fat;

  IngredientAnalysis({
    required this.name,
    this.amount,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
  });

  factory IngredientAnalysis.fromJson(Map<String, dynamic> json) {
    return IngredientAnalysis(
      name: json['name'] as String? ?? 'Unknown',
      amount: json['amount'] as String?,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };
}

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: AppConstants.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 4096,
      ),
    );
  }

  Future<FoodAnalysisResult> analyzeFood(Uint8List imageBytes) async {
    final prompt = '''
Analyze this food image and provide nutritional information.

Please respond in the following JSON format only, without any markdown formatting or code blocks:
{
  "name": "Name of the dish/food",
  "calories": total calories (integer),
  "protein": protein in grams (number),
  "carbs": carbohydrates in grams (number),
  "fat": fat in grams (number),
  "ingredients": [
    {
      "name": "ingredient name",
      "amount": "estimated amount (e.g., '1 cup', '100g')",
      "calories": calories for this ingredient (integer),
      "protein": protein in grams (number),
      "carbs": carbs in grams (number),
      "fat": fat in grams (number)
    }
  ]
}

Important:
- Estimate portion sizes based on the image
- Provide realistic nutritional values
- List all visible ingredients
- If you cannot identify the food, make your best guess
- Return ONLY the JSON object, no other text
''';

    try {
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('Empty response from Gemini');
      }

      // Clean up the response - remove markdown code blocks if present
      String jsonString = text.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      } else if (jsonString.startsWith('```')) {
        jsonString = jsonString.substring(3);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      jsonString = jsonString.trim();

      // Parse JSON
      final Map<String, dynamic> jsonResult = _parseJson(jsonString);
      return FoodAnalysisResult.fromJson(jsonResult);
    } catch (e) {
      // Return a default result if analysis fails
      return FoodAnalysisResult(
        name: 'Unknown Food',
        calories: 0,
        protein: 0,
        carbs: 0,
        fat: 0,
        ingredients: [],
      );
    }
  }

  Map<String, dynamic> _parseJson(String jsonString) {
    // Simple JSON parser for the expected format
    try {
      return Map<String, dynamic>.from(
        (const JsonDecoder().convert(jsonString)) as Map,
      );
    } catch (e) {
      throw FormatException('Failed to parse JSON: $e');
    }
  }
}

class JsonDecoder {
  const JsonDecoder();

  dynamic convert(String input) {
    return _parse(input.trim(), 0).value;
  }

  ({dynamic value, int position}) _parse(String input, int pos) {
    pos = _skipWhitespace(input, pos);
    if (pos >= input.length) throw const FormatException('Unexpected end');

    final char = input[pos];
    if (char == '{') return _parseObject(input, pos);
    if (char == '[') return _parseArray(input, pos);
    if (char == '"') return _parseString(input, pos);
    if (char == 't' || char == 'f') return _parseBoolean(input, pos);
    if (char == 'n') return _parseNull(input, pos);
    if (char == '-' || (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)) {
      return _parseNumber(input, pos);
    }
    throw FormatException('Unexpected character at position $pos');
  }

  int _skipWhitespace(String input, int pos) {
    while (pos < input.length && ' \t\n\r'.contains(input[pos])) {
      pos++;
    }
    return pos;
  }

  ({Map<String, dynamic> value, int position}) _parseObject(String input, int pos) {
    final result = <String, dynamic>{};
    pos++; // skip '{'
    pos = _skipWhitespace(input, pos);

    if (pos < input.length && input[pos] == '}') {
      return (value: result, position: pos + 1);
    }

    while (true) {
      pos = _skipWhitespace(input, pos);
      final keyResult = _parseString(input, pos);
      final key = keyResult.value;
      pos = keyResult.position;

      pos = _skipWhitespace(input, pos);
      if (input[pos] != ':') throw FormatException('Expected ":" at $pos');
      pos++;

      final valueResult = _parse(input, pos);
      result[key] = valueResult.value;
      pos = valueResult.position;

      pos = _skipWhitespace(input, pos);
      if (input[pos] == '}') return (value: result, position: pos + 1);
      if (input[pos] != ',') throw FormatException('Expected "," or "}" at $pos');
      pos++;
    }
  }

  ({List<dynamic> value, int position}) _parseArray(String input, int pos) {
    final result = <dynamic>[];
    pos++; // skip '['
    pos = _skipWhitespace(input, pos);

    if (pos < input.length && input[pos] == ']') {
      return (value: result, position: pos + 1);
    }

    while (true) {
      final valueResult = _parse(input, pos);
      result.add(valueResult.value);
      pos = valueResult.position;

      pos = _skipWhitespace(input, pos);
      if (input[pos] == ']') return (value: result, position: pos + 1);
      if (input[pos] != ',') throw FormatException('Expected "," or "]" at $pos');
      pos++;
    }
  }

  ({String value, int position}) _parseString(String input, int pos) {
    pos++; // skip opening quote
    final buffer = StringBuffer();

    while (pos < input.length) {
      final char = input[pos];
      if (char == '"') return (value: buffer.toString(), position: pos + 1);
      if (char == '\\') {
        pos++;
        if (pos >= input.length) throw const FormatException('Unexpected end');
        final escaped = input[pos];
        switch (escaped) {
          case '"':
          case '\\':
          case '/':
            buffer.write(escaped);
            break;
          case 'b':
            buffer.write('\b');
            break;
          case 'f':
            buffer.write('\f');
            break;
          case 'n':
            buffer.write('\n');
            break;
          case 'r':
            buffer.write('\r');
            break;
          case 't':
            buffer.write('\t');
            break;
          case 'u':
            if (pos + 4 >= input.length) throw const FormatException('Invalid unicode');
            final hex = input.substring(pos + 1, pos + 5);
            buffer.writeCharCode(int.parse(hex, radix: 16));
            pos += 4;
            break;
          default:
            buffer.write(escaped);
        }
      } else {
        buffer.write(char);
      }
      pos++;
    }
    throw const FormatException('Unterminated string');
  }

  ({num value, int position}) _parseNumber(String input, int pos) {
    final start = pos;
    if (input[pos] == '-') pos++;

    while (pos < input.length && input[pos].codeUnitAt(0) >= 48 && input[pos].codeUnitAt(0) <= 57) {
      pos++;
    }

    if (pos < input.length && input[pos] == '.') {
      pos++;
      while (pos < input.length && input[pos].codeUnitAt(0) >= 48 && input[pos].codeUnitAt(0) <= 57) {
        pos++;
      }
    }

    if (pos < input.length && (input[pos] == 'e' || input[pos] == 'E')) {
      pos++;
      if (pos < input.length && (input[pos] == '+' || input[pos] == '-')) pos++;
      while (pos < input.length && input[pos].codeUnitAt(0) >= 48 && input[pos].codeUnitAt(0) <= 57) {
        pos++;
      }
    }

    final numStr = input.substring(start, pos);
    final value = numStr.contains('.') || numStr.contains('e') || numStr.contains('E')
        ? double.parse(numStr)
        : int.parse(numStr);
    return (value: value, position: pos);
  }

  ({bool value, int position}) _parseBoolean(String input, int pos) {
    if (input.substring(pos).startsWith('true')) {
      return (value: true, position: pos + 4);
    }
    if (input.substring(pos).startsWith('false')) {
      return (value: false, position: pos + 5);
    }
    throw FormatException('Expected boolean at $pos');
  }

  ({Null value, int position}) _parseNull(String input, int pos) {
    if (input.substring(pos).startsWith('null')) {
      return (value: null, position: pos + 4);
    }
    throw FormatException('Expected null at $pos');
  }
}
