import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { WeightLogEntity, UserEntity, type WeightLog, type User } from '@/entities';
import { MoreThanOrEqual } from 'typeorm';

const createWeightLogSchema = z.object({
  userId: z.string().uuid().optional(),
  weight: z.number().positive(),
  note: z.string().optional(),
}).refine(data => data.userId, {
  message: "userId is required",
});

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId');
    const limit = parseInt(searchParams.get('limit') || '100');
    const range = searchParams.get('range');

    if (!userId) {
      return NextResponse.json(
        { error: 'userId is required' },
        { status: 400 }
      );
    }

    const weightLogRepo = await getRepository<WeightLog>(WeightLogEntity);

    let whereClause: object = { user_id: userId };

    if (range && range !== 'all') {
      const now = new Date();
      let startDate: Date;

      switch (range) {
        case '90d':
          startDate = new Date(now.setDate(now.getDate() - 90));
          break;
        case '6m':
          startDate = new Date(now.setMonth(now.getMonth() - 6));
          break;
        case '1y':
          startDate = new Date(now.setFullYear(now.getFullYear() - 1));
          break;
        default:
          startDate = new Date(0);
      }

      whereClause = {
        user_id: userId,
        logged_at: MoreThanOrEqual(startDate),
      };
    }

    const logs = await weightLogRepo.find({
      where: whereClause,
      order: { logged_at: 'DESC' },
      take: limit,
    });

    const weights = logs.map(log => Number(log.weight));
    const currentWeight = weights[0] || 0;
    const startWeight = weights[weights.length - 1] || currentWeight;
    const minWeight = weights.length > 0 ? Math.min(...weights) : 0;
    const maxWeight = weights.length > 0 ? Math.max(...weights) : 0;
    const avgWeight = weights.length > 0
      ? weights.reduce((a, b) => a + b, 0) / weights.length
      : 0;

    // Map to camelCase for frontend compatibility
    const mappedLogs = logs.map(log => ({
      id: log.id,
      userId: log.user_id,
      weight: Number(log.weight),
      note: log.note,
      loggedAt: log.logged_at,
    }));

    return NextResponse.json({
      logs: mappedLogs,
      stats: {
        currentWeight,
        startWeight,
        minWeight,
        maxWeight,
        avgWeight,
        totalChange: currentWeight - startWeight,
        totalEntries: logs.length,
      },
    });
  } catch (error) {
    console.error('Get weight logs error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = createWeightLogSchema.parse(body);

    const weightLogRepo = await getRepository<WeightLog>(WeightLogEntity);
    const userRepo = await getRepository<User>(UserEntity);

    const finalUserId = validatedData.userId;
    const log = weightLogRepo.create({
      user_id: finalUserId,
      weight: validatedData.weight,
      note: validatedData.note || null,
    });

    await weightLogRepo.save(log);

    await userRepo.update(
      { id: finalUserId },
      { current_weight: validatedData.weight }
    );

    return NextResponse.json({
      id: log.id,
      userId: log.user_id,
      weight: Number(log.weight),
      note: log.note,
      loggedAt: log.logged_at,
    }, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Create weight log error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
