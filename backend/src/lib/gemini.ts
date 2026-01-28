const OPENROUTER_API_URL = 'https://openrouter.ai/api/v1/chat/completions';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY!;

function getLanguageInstruction(locale: string): string {
  const languageMap: Record<string, string> = {
    'ko': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in Korean (한국어) ONLY. Do NOT include any English text.',
    'ja': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in Japanese (日本語) ONLY. Do NOT include any English text.',
    'zh': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in Chinese (中文) ONLY. Do NOT include any English text.',
    'es': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in Spanish (Español) ONLY. Do NOT include any English text.',
    'fr': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in French (Français) ONLY. Do NOT include any English text.',
    'de': 'IMPORTANT: ALL text responses including food names, ingredient names, and descriptions MUST be in German (Deutsch) ONLY. Do NOT include any English text.',
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

export interface ExerciseAnalysisResult {
  exercise_type: string;
  duration: number;
  calories_burned: number;
  intensity: string | null;
  description: string | null;
}

export async function analyzeExercise(description: string, locale: string = 'en'): Promise<ExerciseAnalysisResult> {
  const languageInstruction = getLanguageInstruction(locale);

  const prompt = `
Analyze this exercise description and estimate the calories burned.
${languageInstruction}

Exercise description: "${description}"

Please respond in the following JSON format only, without any markdown formatting or code blocks:
{
  "exercise_type": "Type of exercise (e.g., 'Running', 'Weight Training', 'Yoga', 'Swimming')",
  "duration": estimated duration in minutes (integer),
  "calories_burned": estimated total calories burned (integer),
  "intensity": "Low" | "Medium" | "High" (based on the description),
  "description": "Brief summary of the exercise"
}

Important:
- If duration is not specified, estimate based on typical workout duration for this type of exercise
- Use realistic calorie estimates based on:
  - Light activity: 3-5 cal/min
  - Moderate activity: 5-8 cal/min
  - Intense activity: 8-15 cal/min
- Consider the type of exercise and intensity
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
            content: prompt,
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

    const parsed = JSON.parse(text) as ExerciseAnalysisResult;
    return parsed;
  } catch (error) {
    console.error('Error analyzing exercise:', error);
    throw error;
  }
}

export async function analyzeTextFood(description: string, locale: string = 'en'): Promise<FoodAnalysisResult> {
  const languageInstruction = getLanguageInstruction(locale);

  const prompt = `
Analyze this food description and provide nutritional information.
${languageInstruction}

Food description: "${description}"

Please respond in the following JSON format only, without any markdown formatting or code blocks:
{
  "name": "Name of the dish/food",
  "calories": total calories (integer),
  "protein": protein in grams (number),
  "carbs": carbohydrates in grams (number),
  "fat": fat in grams (number),
  "fiber": fiber in grams (number, REQUIRED - estimate based on ingredients like vegetables, whole grains, fruits),
  "sugar": sugar in grams (number, REQUIRED - estimate based on ingredients like fruits, sauces, sweeteners),
  "sodium": sodium in milligrams (number, REQUIRED - estimate based on salt, soy sauce, processed ingredients),
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

CRITICAL REQUIREMENTS:
- ALL fields must be provided with realistic non-zero values when applicable
- fiber: Estimate based on vegetables, whole grains, legumes, fruits. Most foods have at least 1-3g fiber.
- sugar: Estimate based on natural sugars (fruits) and added sugars (sauces, drinks). Rice/noodle dishes typically have 2-5g, sweet items have more.
- sodium: Estimate based on salt, soy sauce, MSG, processed ingredients. Most cooked meals have 300-800mg. Korean/Asian food typically has 500-1500mg.
- Estimate portion sizes based on the description
- Provide realistic nutritional values
- List main ingredients
- If the description is vague, estimate based on typical serving sizes
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
            content: prompt,
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
    console.error('Error analyzing text food:', error);
    return {
      name: description,
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

export async function analyzeFood(imageUrl: string, locale: string = 'en'): Promise<FoodAnalysisResult> {
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
  "fiber": fiber in grams (number, REQUIRED - estimate based on ingredients like vegetables, whole grains, fruits),
  "sugar": sugar in grams (number, REQUIRED - estimate based on ingredients like fruits, sauces, sweeteners),
  "sodium": sodium in milligrams (number, REQUIRED - estimate based on salt, soy sauce, processed ingredients),
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

CRITICAL REQUIREMENTS:
- ALL fields must be provided with realistic non-zero values when applicable
- fiber: Estimate based on vegetables, whole grains, legumes, fruits. Most foods have at least 1-3g fiber.
- sugar: Estimate based on natural sugars (fruits) and added sugars (sauces, drinks). Rice/noodle dishes typically have 2-5g, sweet items have more.
- sodium: Estimate based on salt, soy sauce, MSG, processed ingredients. Most cooked meals have 300-800mg. Korean/Asian food typically has 500-1500mg.
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
                  url: imageUrl,
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
