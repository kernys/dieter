import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { FoodEntryEntity, type FoodEntry, dumpFoodEntry } from '@/entities';
import { Between } from 'typeorm';

const createFoodEntrySchema = z.object({
  name: z.string(),
  calories: z.number(),
  protein: z.number(),
  carbs: z.number(),
  fat: z.number(),
  fiber: z.number().default(0),
  sugar: z.number().default(0),
  sodium: z.number().default(0),
  imageUrl: z.string().nullish(),
  ingredients: z.array(z.object({
    name: z.string(),
    amount: z.string().nullable(),
    calories: z.number(),
    protein: z.number().nullable(),
    carbs: z.number().nullable(),
    fat: z.number().nullable(),
  })).nullish(),
  servings: z.number().default(1),
  loggedAt: z.string().datetime().optional(), // ISO 8601 datetime string for past date entries
});

export async function GET(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    const { searchParams } = new URL(request.url);
    const date = searchParams.get('date');

    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
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
    const totalFiber = entries.reduce((sum, entry) => sum + Number(entry.fiber || 0) * Number(entry.servings), 0);
    const totalSugar = entries.reduce((sum, entry) => sum + Number(entry.sugar || 0) * Number(entry.servings), 0);
    const totalSodium = entries.reduce((sum, entry) => sum + Number(entry.sodium || 0) * Number(entry.servings), 0);

    return NextResponse.json({
      entries: entries.map(dumpFoodEntry),
      summary: {
        totalCalories,
        totalProtein,
        totalCarbs,
        totalFat,
        totalFiber,
        totalSugar,
        totalSodium,
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
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const body = await request.json();
    const validatedData = createFoodEntrySchema.parse(body);

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);

    const entry = foodEntryRepo.create({
      user_id: userId,
      name: validatedData.name,
      calories: validatedData.calories,
      protein: validatedData.protein,
      carbs: validatedData.carbs,
      fat: validatedData.fat,
      fiber: validatedData.fiber,
      sugar: validatedData.sugar,
      sodium: validatedData.sodium,
      image_url: validatedData.imageUrl,
      ingredients: validatedData.ingredients || null,
      servings: validatedData.servings,
      // Use provided loggedAt or default to now
      logged_at: validatedData.loggedAt ? new Date(validatedData.loggedAt) : new Date(),
    });

    await foodEntryRepo.save(entry);

    return NextResponse.json(dumpFoodEntry(entry), { status: 201 });
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
