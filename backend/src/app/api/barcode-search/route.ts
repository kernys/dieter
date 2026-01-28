import { NextRequest, NextResponse } from 'next/server';

const RAPIDAPI_KEY = '50b6fdc8f5msh6ac400567f607c3p1bbacdjsnc2e9448c6b0b';
const RAPIDAPI_HOST = 'dietagram.p.rapidapi.com';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const barcode = searchParams.get('barcode');

    if (!barcode) {
      return NextResponse.json(
        { error: 'barcode parameter is required' },
        { status: 400 }
      );
    }

    const response = await fetch(
      `https://dietagram.p.rapidapi.com/apiBarcode.php?name=${encodeURIComponent(barcode)}`,
      {
        method: 'GET',
        headers: {
          'x-rapidapi-key': RAPIDAPI_KEY,
          'x-rapidapi-host': RAPIDAPI_HOST,
        },
      }
    );

    if (!response.ok) {
      console.error('Dietagram Barcode API error:', response.status, response.statusText);
      return NextResponse.json(
        { error: 'Failed to fetch barcode data' },
        { status: response.status }
      );
    }

    const data = await response.json();

    // Check if product was found
    if (!data || (Array.isArray(data) && data.length === 0)) {
      return NextResponse.json(
        { error: 'Product not found', found: false },
        { status: 404 }
      );
    }

    // Transform the response to a consistent format
    const product = Array.isArray(data) ? data[0] : data;

    const transformedProduct = {
      found: true,
      barcode: barcode,
      name: product.name || product.product_name || product.food_name || 'Unknown Product',
      brand: product.brand || product.brands || null,
      calories: Number(product.calories || product.kcal || product.energy_kcal || product.energy || 0),
      protein: Number(product.protein || product.proteins || product.proteins_100g || 0),
      carbs: Number(product.carbs || product.carbohydrates || product.carbohydrates_100g || 0),
      fat: Number(product.fat || product.fats || product.fat_100g || 0),
      fiber: Number(product.fiber || product.fibre || product.dietary_fiber || product.fiber_100g || 0),
      sugar: Number(product.sugar || product.sugars || product.sugars_100g || 0),
      sodium: Number(product.sodium || product.salt || product.sodium_100g || (product.salt_100g ? product.salt_100g * 400 : 0) || 0),
      servingSize: product.serving_size || product.servingSize || product.quantity || '100g',
      imageUrl: product.image || product.image_url || product.imageUrl || null,
    };

    return NextResponse.json(transformedProduct);
  } catch (error) {
    console.error('Barcode search error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
