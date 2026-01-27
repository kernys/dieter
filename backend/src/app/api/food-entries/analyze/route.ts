import { NextRequest, NextResponse } from 'next/server';
import { analyzeFood } from '@/lib/gemini';
import { getUserFromRequest } from '@/lib/auth';
import { getRepository } from '@/lib/database';
import { FoodEntryEntity, type FoodEntry, dumpFoodEntry } from '@/entities';
import { z } from 'zod';

const analyzeSchema = z.object({
  imageUrl: z.string().url(), // URL of the uploaded image (permanent)
  locale: z.string().optional(), // User's locale for localized food names
  autoRegister: z.boolean().optional(), // If true, automatically create food entry
  loggedAt: z.string().datetime().optional(), // ISO 8601 datetime for past date entries
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
    const { imageUrl, locale, autoRegister, loggedAt } = analyzeSchema.parse(body);

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
        fiber: result.fiber,
        sugar: result.sugar,
        sodium: result.sodium,
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
        // Use provided loggedAt or default to now
        logged_at: loggedAt ? new Date(loggedAt) : new Date(),
      });

      await foodEntryRepo.save(entry);

      // Return both analysis result and the created entry
      return NextResponse.json({
        ...result,
        entry: dumpFoodEntry(entry),
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
