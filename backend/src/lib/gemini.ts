const OPENROUTER_API_URL = 'https://openrouter.ai/api/v1/chat/completions';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY!;

function getLanguageInstruction(locale: string): string {
  const languageMap: Record<string, string> = {
    'ko': 'Respond with food names and ingredient names in Korean (한국어).',
    'ja': 'Respond with food names and ingredient names in Japanese (日本語).',
    'zh': 'Respond with food names and ingredient names in Chinese (中文).',
    'es': 'Respond with food names and ingredient names in Spanish (Español).',
    'fr': 'Respond with food names and ingredient names in French (Français).',
    'de': 'Respond with food names and ingredient names in German (Deutsch).',
  };

  return languageMap[locale] || '';
}

export interface FoodAnalysisResult {
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  fiber: number;
  sugar: number;
  sodium: number;
  health_score: number;
  ingredients: IngredientAnalysis[];
}

export interface IngredientAnalysis {
  name: string;
  amount: string | null;
  calories: number;
  protein: number | null;
  carbs: number | null;
  fat: number | null;
}

export async function analyzeFood(imageBase64: string, locale: string = 'en'): Promise<FoodAnalysisResult> {
  const languageInstruction = getLanguageInstruction(locale);

  const prompt = `
Analyze this food image and provide nutritional information.
${languageInstruction}

Please respond in the following JSON format only, without any markdown formatting or code blocks:
{
  "name": "Name of the dish/food",
  "calories": total calories (integer),
  "protein": protein in grams (number),
  "carbs": carbohydrates in grams (number),
  "fat": fat in grams (number),
  "fiber": fiber in grams (number),
  "sugar": sugar in grams (number),
  "sodium": sodium in milligrams (number),
  "health_score": health score from 1-10 (integer, 10 being healthiest),
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
- health_score: Consider factors like whole foods, vegetables, processed ingredients, sodium, sugar content. 1 = very unhealthy (junk food), 10 = very healthy (fresh vegetables, lean protein)
- Return ONLY the JSON object, no other text
`;

  try {
    const response = await fetch(OPENROUTER_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': process.env.OPENROUTER_HTTP_REFERER || '',
        'X-Title': 'Dieter AI',
      },
      body: JSON.stringify({
        model: 'google/gemini-2.5-flash',
        messages: [
          {
            role: 'user',
            content: [
              {
                type: 'text',
                text: prompt,
              },
              {
                type: 'image_url',
                image_url: {
                  url: `data:image/jpeg;base64,${imageBase64}`,
                },
              },
            ],
          },
        ],
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error('OpenRouter API error:', response.status, errorText);
      throw new Error(`OpenRouter API error: ${response.status}`);
    }

    const data = await response.json();
    let text = data.choices[0]?.message?.content || '';

    if (!text) {
      throw new Error('No response content from OpenRouter');
    }

    // Clean up the response
    text = text.trim();
    if (text.startsWith('```json')) {
      text = text.substring(7);
    } else if (text.startsWith('```')) {
      text = text.substring(3);
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    text = text.trim();

    const parsed = JSON.parse(text) as FoodAnalysisResult;
    return parsed;
  } catch (error) {
    console.error('Error analyzing food:', error);
    return {
      name: 'Unknown Food',
      calories: 0,
      protein: 0,
      carbs: 0,
      fat: 0,
      fiber: 0,
      sugar: 0,
      sodium: 0,
      health_score: 5,
      ingredients: [],
    };
  }
}
