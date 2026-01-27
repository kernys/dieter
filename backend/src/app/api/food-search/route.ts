import { NextRequest, NextResponse } from 'next/server';
import { analyzeTextFood } from '@/lib/gemini';

const RAPIDAPI_KEY = '50b6fdc8f5msh6ac400567f607c3p1bbacdjsnc2e9448c6b0b';
const RAPIDAPI_HOST = 'dietagram.p.rapidapi.com';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const name = searchParams.get('name');
    const lang = searchParams.get('lang') || 'en';

    if (!name) {
      return NextResponse.json(
        { error: 'name parameter is required' },
        { status: 400 }
      );
    }

    // Try external API first
    let transformedFoods: Array<{
      id: string;
      name: string;
      calories: number;
      protein: number;
      carbs: number;
      fat: number;
      fiber: number;
      sugar: number;
      sodium: number;
      servingSize: string;
      imageUrl: string | null;
      source: 'database' | 'ai';
    }> = [];

    try {
      const response = await fetch(
        `https://dietagram.p.rapidapi.com/apiFood.php?name=${encodeURIComponent(name)}&lang=${lang}`,
        {
          method: 'GET',
          headers: {
            'x-rapidapi-key': RAPIDAPI_KEY,
            'x-rapidapi-host': RAPIDAPI_HOST,
          },
        }
      );

      if (response.ok) {
        const data = await response.json();
        const foods = Array.isArray(data) ? data : (data.dishes || data.foods || []);

        transformedFoods = foods.map((food: Record<string, unknown>) => ({
          id: food.id || String(Math.random()),
          name: food.name || food.food_name || 'Unknown',
          calories: Number(food.calories || food.caloric || food.kcal || 0),
          protein: Number(food.protein || food.proteins || 0),
          carbs: Number(food.carbs || food.carbohydrates || food.carbon || 0),
          fat: Number(food.fat || food.fats || food.lippieds || 0),
          fiber: Number(food.fiber || food.fibers || 0),
          sugar: Number(food.sugar || food.sugars || 0),
          sodium: Number(food.sodium || 0),
          servingSize: food.serving_size || food.servingSize || food.portion || '100g',
          imageUrl: food.image || food.imageUrl || food.photo || null,
          source: 'database' as const,
        }));
      }
    } catch (apiError) {
      console.error('External API error, falling back to AI:', apiError);
    }

    // If no results from API, use AI to analyze the food
    if (transformedFoods.length === 0) {
      console.log(`No results for "${name}", using AI analysis`);
      
      try {
        const aiResult = await analyzeTextFood(name, lang);
        
        transformedFoods = [{
          id: `ai-${Date.now()}`,
          name: aiResult.name,
          calories: aiResult.calories,
          protein: aiResult.protein,
          carbs: aiResult.carbs,
          fat: aiResult.fat,
          fiber: aiResult.fiber,
          sugar: aiResult.sugar,
          sodium: aiResult.sodium,
          servingSize: '1 serving',
          imageUrl: null,
          source: 'ai' as const,
        }];
      } catch (aiError) {
        console.error('AI analysis error:', aiError);
      }
    }

    return NextResponse.json({
      foods: transformedFoods,
      query: name,
    });
  } catch (error) {
    console.error('Food search error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
