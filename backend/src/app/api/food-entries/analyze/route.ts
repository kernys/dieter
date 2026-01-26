import { NextRequest, NextResponse } from 'next/server';
import { analyzeFood } from '@/lib/gemini';
import { getUserFromRequest } from '@/lib/auth';
import { getRepository } from '@/lib/database';
import { FoodEntryEntity, type FoodEntry } from '@/entities';
import { z } from 'zod';

const analyzeSchema = z.object({
  imageUrl: z.string().url(), // URL of the uploaded image (permanent)
  locale: z.string().optional(), // User's locale for localized food names
  autoRegister: z.boolean().optional(), // If true, automatically create food entry
});

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
    const { imageUrl, locale, autoRegister } = analyzeSchema.parse(body);

    const result = await analyzeFood(imageUrl, locale);

    // If autoRegister is true, create the food entry automatically
    if (autoRegister) {
      const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);

      const entry = foodEntryRepo.create({
        user_id: userId,
        name: result.name,
        calories: result.calories,
        protein: result.protein,
        carbs: result.carbs,
        fat: result.fat,
        image_url: imageUrl,
        ingredients: result.ingredients.map(i => ({
          name: i.name,
          amount: i.amount,
          calories: i.calories,
          protein: i.protein,
          carbs: i.carbs,
          fat: i.fat,
        })),
        servings: 1,
      });

      await foodEntryRepo.save(entry);

      // Return both analysis result and the created entry
      return NextResponse.json({
        ...result,
        entry: {
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
        },
      });
    }

    return NextResponse.json(result);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Analyze food error:', error);
    return NextResponse.json(
      { error: 'Failed to analyze food image' },
      { status: 500 }
    );
  }
}
