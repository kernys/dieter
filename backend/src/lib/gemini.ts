const OPENROUTER_API_URL = 'https://openrouter.ai/api/v1/chat/completions';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY!;

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
    const response = await fetch(OPENROUTER_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': process.env.OPENROUTER_HTTP_REFERER || '',
        'X-Title': 'Dieter AI',
      },
      body: JSON.stringify({
        model: 'google/gemini-1.5-flash',
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
      ingredients: [],
    };
  }
}
