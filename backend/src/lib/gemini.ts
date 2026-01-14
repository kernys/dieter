import { GoogleGenerativeAI } from '@google/generative-ai';

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY!);

export interface FoodAnalysisResult {
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
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

export async function analyzeFood(imageBase64: string): Promise<FoodAnalysisResult> {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

  const prompt = `
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
`;

  try {
    const result = await model.generateContent([
      prompt,
      {
        inlineData: {
          mimeType: 'image/jpeg',
          data: imageBase64,
        },
      },
    ]);

    const response = await result.response;
    let text = response.text();

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
      ingredients: [],
    };
  }
}
