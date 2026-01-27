import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { ExerciseEntryEntity, type ExerciseEntry, dumpExerciseEntry } from '@/entities';
import { z } from 'zod';
import { Between } from 'typeorm';

const createExerciseEntrySchema = z.object({
  type: z.string().min(1),
  duration: z.number().min(0).default(0),
  caloriesBurned: z.number().min(0),
  intensity: z.string().nullable().optional(),
  description: z.string().nullable().optional(),
  loggedAt: z.string().datetime().optional(),
});

export async function GET(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { searchParams } = new URL(request.url);
    const dateParam = searchParams.get('date');
    
    const exerciseEntryRepo = await getRepository<ExerciseEntry>(ExerciseEntryEntity);
    
    let entries: ExerciseEntry[];
    
    if (dateParam) {
      // Get entries for a specific date
      const date = new Date(dateParam);
      const startOfDay = new Date(date);
      startOfDay.setHours(0, 0, 0, 0);
      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);
      
      entries = await exerciseEntryRepo.find({
        where: {
          user_id: userId,
          logged_at: Between(startOfDay, endOfDay),
        },
        order: { logged_at: 'DESC' },
      });
    } else {
      // Get all entries (with limit)
      entries = await exerciseEntryRepo.find({
        where: { user_id: userId },
        order: { logged_at: 'DESC' },
        take: 100,
      });
    }
    
    const totalCaloriesBurned = entries.reduce((sum, entry) => sum + Number(entry.calories_burned), 0);
    
    return NextResponse.json({
      entries: entries.map(dumpExerciseEntry),
      summary: {
        totalCaloriesBurned,
        entryCount: entries.length,
      },
    });
  } catch (error) {
    console.error('Get exercise entries error:', error);
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
    const validatedData = createExerciseEntrySchema.parse(body);

    const exerciseEntryRepo = await getRepository<ExerciseEntry>(ExerciseEntryEntity);

    const newEntry = exerciseEntryRepo.create({
      user_id: userId,
      type: validatedData.type,
      duration: validatedData.duration,
      calories_burned: validatedData.caloriesBurned,
      intensity: validatedData.intensity ?? null,
      description: validatedData.description ?? null,
      logged_at: validatedData.loggedAt ? new Date(validatedData.loggedAt) : new Date(),
    });

    const savedEntry = await exerciseEntryRepo.save(newEntry);

    return NextResponse.json(dumpExerciseEntry(savedEntry), { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation error', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Create exercise entry error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
