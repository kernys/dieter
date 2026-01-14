import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';

const createFoodEntrySchema = z.object({
  user_id: z.string().uuid(),
  name: z.string(),
  calories: z.number(),
  protein: z.number(),
  carbs: z.number(),
  fat: z.number(),
  image_url: z.string().optional(),
  ingredients: z.array(z.object({
    name: z.string(),
    amount: z.string().nullable(),
    calories: z.number(),
    protein: z.number().nullable(),
    carbs: z.number().nullable(),
    fat: z.number().nullable(),
  })).optional(),
  servings: z.number().default(1),
});

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('user_id');
    const date = searchParams.get('date');

    if (!userId) {
      return NextResponse.json(
        { error: 'user_id is required' },
        { status: 400 }
      );
    }

    let query = supabase
      .from('food_entries')
      .select('*')
      .eq('user_id', userId)
      .order('logged_at', { ascending: false });

    if (date) {
      const startOfDay = new Date(date);
      startOfDay.setHours(0, 0, 0, 0);
      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);

      query = query
        .gte('logged_at', startOfDay.toISOString())
        .lte('logged_at', endOfDay.toISOString());
    }

    const { data, error } = await query;

    if (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    // Calculate daily summary
    const totalCalories = data.reduce((sum, entry) => sum + entry.calories * entry.servings, 0);
    const totalProtein = data.reduce((sum, entry) => sum + entry.protein * entry.servings, 0);
    const totalCarbs = data.reduce((sum, entry) => sum + entry.carbs * entry.servings, 0);
    const totalFat = data.reduce((sum, entry) => sum + entry.fat * entry.servings, 0);

    return NextResponse.json({
      entries: data,
      summary: {
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
      },
    });
  } catch (error) {
    console.error('Get food entries error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = createFoodEntrySchema.parse(body);

    const { data, error } = await supabase
      .from('food_entries')
      .insert({
        id: uuidv4(),
        ...validatedData,
        logged_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    return NextResponse.json(data, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.errors },
        { status: 400 }
      );
    }
    console.error('Create food entry error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
