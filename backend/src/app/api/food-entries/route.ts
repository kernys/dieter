import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { FoodEntryEntity, type FoodEntry } from '@/entities';
import { Between } from 'typeorm';

const createFoodEntrySchema = z.object({
  user_id: z.string().uuid(),
  name: z.string(),
  calories: z.number(),
  protein: z.number(),
  carbs: z.number(),
  fat: z.number(),
  image_url: z.string().nullish(),
  ingredients: z.array(z.object({
    name: z.string(),
    amount: z.string().nullable(),
    calories: z.number(),
    protein: z.number().nullable(),
    carbs: z.number().nullable(),
    fat: z.number().nullable(),
  })).nullish(),
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

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);

    let whereClause: object = { user_id: userId };

    if (date) {
      const startOfDay = new Date(date);
      startOfDay.setHours(0, 0, 0, 0);
      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);

      whereClause = {
        user_id: userId,
        logged_at: Between(startOfDay, endOfDay),
      };
    }

    const entries = await foodEntryRepo.find({
      where: whereClause,
      order: { logged_at: 'DESC' },
    });

    const totalCalories = entries.reduce((sum, entry) => sum + Number(entry.calories) * Number(entry.servings), 0);
    const totalProtein = entries.reduce((sum, entry) => sum + Number(entry.protein) * Number(entry.servings), 0);
    const totalCarbs = entries.reduce((sum, entry) => sum + Number(entry.carbs) * Number(entry.servings), 0);
    const totalFat = entries.reduce((sum, entry) => sum + Number(entry.fat) * Number(entry.servings), 0);

    // Map to camelCase for frontend compatibility
    const mappedEntries = entries.map(entry => ({
      id: entry.id,
      userId: entry.user_id,
      name: entry.name,
      calories: Number(entry.calories),
      protein: Number(entry.protein),
      carbs: Number(entry.carbs),
      fat: Number(entry.fat),
      imageUrl: entry.image_url,
      ingredients: entry.ingredients,
      servings: Number(entry.servings),
      loggedAt: entry.logged_at,
    }));

    return NextResponse.json({
      entries: mappedEntries,
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

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);

    const entry = foodEntryRepo.create({
      user_id: validatedData.user_id,
      name: validatedData.name,
      calories: validatedData.calories,
      protein: validatedData.protein,
      carbs: validatedData.carbs,
      fat: validatedData.fat,
      image_url: validatedData.image_url || null,
      ingredients: validatedData.ingredients || null,
      servings: validatedData.servings,
    });

    await foodEntryRepo.save(entry);

    // Return camelCase for frontend compatibility
    return NextResponse.json({
      id: entry.id,
      userId: entry.user_id,
      name: entry.name,
      calories: Number(entry.calories),
      protein: Number(entry.protein),
      carbs: Number(entry.carbs),
      fat: Number(entry.fat),
      imageUrl: entry.image_url,
      ingredients: entry.ingredients,
      servings: Number(entry.servings),
      loggedAt: entry.logged_at,
    }, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
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
