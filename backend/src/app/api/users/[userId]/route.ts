import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { UserEntity, type User } from '@/entities';

const updateUserSchema = z.object({
  name: z.string().optional(),
  daily_calorie_goal: z.number().optional(),
  daily_protein_goal: z.number().optional(),
  daily_carbs_goal: z.number().optional(),
  daily_fat_goal: z.number().optional(),
  current_weight: z.number().optional(),
  goal_weight: z.number().optional(),
});

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ userId: string }> }
) {
  try {
    const { userId } = await params;

    const userRepo = await getRepository<User>(UserEntity);
    const user = await userRepo.findOne({ where: { id: userId } });

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatar_url,
      dailyCalorieGoal: user.daily_calorie_goal,
      dailyProteinGoal: user.daily_protein_goal,
      dailyCarbsGoal: user.daily_carbs_goal,
      dailyFatGoal: user.daily_fat_goal,
      currentWeight: user.current_weight,
      goalWeight: user.goal_weight,
      createdAt: user.created_at,
    });
  } catch (error) {
    console.error('Get user error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ userId: string }> }
) {
  try {
    const { userId } = await params;
    const body = await request.json();
    const updates = updateUserSchema.parse(body);

    const userRepo = await getRepository<User>(UserEntity);
    const user = await userRepo.findOne({ where: { id: userId } });

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    Object.assign(user, updates);
    await userRepo.save(user);

    return NextResponse.json({
      id: user.id,
      email: user.email,
      name: user.name,
      avatarUrl: user.avatar_url,
      dailyCalorieGoal: user.daily_calorie_goal,
      dailyProteinGoal: user.daily_protein_goal,
      dailyCarbsGoal: user.daily_carbs_goal,
      dailyFatGoal: user.daily_fat_goal,
      currentWeight: user.current_weight,
      goalWeight: user.goal_weight,
      createdAt: user.created_at,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Update user error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
