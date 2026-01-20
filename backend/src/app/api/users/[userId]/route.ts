import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { UserEntity, type User } from '@/entities';

const updateUserSchema = z.object({
  name: z.string().optional(),
  dailyCalorieGoal: z.number().optional(),
  dailyProteinGoal: z.number().optional(),
  dailyCarbsGoal: z.number().optional(),
  dailyFatGoal: z.number().optional(),
  currentWeight: z.number().optional(),
  goalWeight: z.number().optional(),
  heightFeet: z.number().optional(),
  heightInches: z.number().optional(),
  heightCm: z.number().optional(),
  birthDate: z.string().optional(),
  gender: z.string().optional(),
  dailyStepGoal: z.number().optional(),
  onboardingCompleted: z.boolean().optional(),
});

// Convert camelCase to snake_case for database
function toSnakeCase(updates: z.infer<typeof updateUserSchema>): Partial<User> {
  const result: Partial<User> = {};
  if (updates.name !== undefined) result.name = updates.name;
  if (updates.dailyCalorieGoal !== undefined) result.daily_calorie_goal = updates.dailyCalorieGoal;
  if (updates.dailyProteinGoal !== undefined) result.daily_protein_goal = updates.dailyProteinGoal;
  if (updates.dailyCarbsGoal !== undefined) result.daily_carbs_goal = updates.dailyCarbsGoal;
  if (updates.dailyFatGoal !== undefined) result.daily_fat_goal = updates.dailyFatGoal;
  if (updates.currentWeight !== undefined) result.current_weight = updates.currentWeight;
  if (updates.goalWeight !== undefined) result.goal_weight = updates.goalWeight;
  if (updates.heightFeet !== undefined) result.height_feet = updates.heightFeet;
  if (updates.heightInches !== undefined) result.height_inches = updates.heightInches;
  if (updates.heightCm !== undefined) result.height_cm = updates.heightCm;
  if (updates.birthDate !== undefined) result.birth_date = updates.birthDate ? new Date(updates.birthDate) : null;
  if (updates.gender !== undefined) result.gender = updates.gender;
  if (updates.dailyStepGoal !== undefined) result.daily_step_goal = updates.dailyStepGoal;
  if (updates.onboardingCompleted !== undefined) result.onboarding_completed = updates.onboardingCompleted;
  return result;
}

// Format user for API response (snake_case to camelCase)
function formatUserResponse(user: User) {
  let birthDateStr: string | null = null;
  if (user.birth_date) {
    // Handle both Date object and string from DB
    if (user.birth_date instanceof Date) {
      birthDateStr = user.birth_date.toISOString().split('T')[0];
    } else {
      birthDateStr = String(user.birth_date).split('T')[0];
    }
  }

  return {
    id: user.id,
    email: user.email,
    name: user.name,
    avatarUrl: user.avatar_url,
    dailyCalorieGoal: Number(user.daily_calorie_goal),
    dailyProteinGoal: Number(user.daily_protein_goal),
    dailyCarbsGoal: Number(user.daily_carbs_goal),
    dailyFatGoal: Number(user.daily_fat_goal),
    currentWeight: user.current_weight ? Number(user.current_weight) : null,
    goalWeight: user.goal_weight ? Number(user.goal_weight) : null,
    heightFeet: user.height_feet ? Number(user.height_feet) : null,
    heightInches: user.height_inches ? Number(user.height_inches) : null,
    heightCm: user.height_cm ? Number(user.height_cm) : null,
    birthDate: birthDateStr,
    gender: user.gender,
    dailyStepGoal: Number(user.daily_step_goal ?? 10000),
    onboardingCompleted: user.onboarding_completed,
    createdAt: user.created_at,
  };
}

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

    return NextResponse.json(formatUserResponse(user));
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

    const snakeCaseUpdates = toSnakeCase(updates);
    Object.assign(user, snakeCaseUpdates);
    await userRepo.save(user);

    return NextResponse.json(formatUserResponse(user));
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
