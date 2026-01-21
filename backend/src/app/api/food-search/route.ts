import { NextRequest, NextResponse } from 'next/server';

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

    if (!response.ok) {
      console.error('Dietagram API error:', response.status, response.statusText);
      return NextResponse.json(
        { error: 'Failed to fetch food data' },
        { status: response.status }
      );
    }

    const data = await response.json();

    // Transform the response to a consistent format
    // apiFood.php returns { dishes: [...] } with fields like caloric, carbon, etc.
    const foods = Array.isArray(data) ? data : (data.dishes || data.foods || []);

    const transformedFoods = foods.map((food: Record<string, unknown>) => ({
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
    }));

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
