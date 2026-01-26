import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { FoodEntryEntity, type FoodEntry, dumpFoodEntry } from '@/entities';

const updateFoodEntrySchema = z.object({
  name: z.string().optional(),
  calories: z.number().optional(),
  protein: z.number().optional(),
  carbs: z.number().optional(),
  fat: z.number().optional(),
  servings: z.number().optional(),
  ingredients: z.array(z.object({
    name: z.string(),
    amount: z.string().nullable(),
    calories: z.number(),
    protein: z.number().nullable(),
    carbs: z.number().nullable(),
    fat: z.number().nullable(),
  })).optional(),
});

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id } = await params;

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);
    const entry = await foodEntryRepo.findOne({ where: { id } });

    if (!entry) {
      return NextResponse.json(
        { error: 'Food entry not found' },
        { status: 404 }
      );
    }

    // Verify ownership
    if (entry.user_id !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    return NextResponse.json(dumpFoodEntry(entry));
  } catch (error) {
    console.error('Get food entry error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id } = await params;
    const body = await request.json();
    const updates = updateFoodEntrySchema.parse(body);

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);
    const entry = await foodEntryRepo.findOne({ where: { id } });

    if (!entry) {
      return NextResponse.json(
        { error: 'Food entry not found' },
        { status: 404 }
      );
    }

    // Verify ownership
    if (entry.user_id !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    Object.assign(entry, updates);
    await foodEntryRepo.save(entry);

    return NextResponse.json(dumpFoodEntry(entry));
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Update food entry error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id } = await params;

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);
    const entry = await foodEntryRepo.findOne({ where: { id } });

    if (!entry) {
      return NextResponse.json(
        { error: 'Food entry not found' },
        { status: 404 }
      );
    }

    // Verify ownership
    if (entry.user_id !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    await foodEntryRepo.remove(entry);

    return NextResponse.json({ message: 'Deleted successfully' });
  } catch (error) {
    console.error('Delete food entry error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
