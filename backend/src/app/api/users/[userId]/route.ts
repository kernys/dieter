import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { UserEntity, type User, dumpUser } from '@/entities';

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
  // Notification settings
  breakfastReminderEnabled: z.boolean().optional(),
  breakfastReminderTime: z.string().optional(),
  lunchReminderEnabled: z.boolean().optional(),
  lunchReminderTime: z.string().optional(),
  snackReminderEnabled: z.boolean().optional(),
  snackReminderTime: z.string().optional(),
  dinnerReminderEnabled: z.boolean().optional(),
  dinnerReminderTime: z.string().optional(),
  endOfDayReminderEnabled: z.boolean().optional(),
  endOfDayReminderTime: z.string().optional(),
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
  // Notification settings
  if (updates.breakfastReminderEnabled !== undefined) result.breakfast_reminder_enabled = updates.breakfastReminderEnabled;
  if (updates.breakfastReminderTime !== undefined) result.breakfast_reminder_time = updates.breakfastReminderTime;
  if (updates.lunchReminderEnabled !== undefined) result.lunch_reminder_enabled = updates.lunchReminderEnabled;
  if (updates.lunchReminderTime !== undefined) result.lunch_reminder_time = updates.lunchReminderTime;
  if (updates.snackReminderEnabled !== undefined) result.snack_reminder_enabled = updates.snackReminderEnabled;
  if (updates.snackReminderTime !== undefined) result.snack_reminder_time = updates.snackReminderTime;
  if (updates.dinnerReminderEnabled !== undefined) result.dinner_reminder_enabled = updates.dinnerReminderEnabled;
  if (updates.dinnerReminderTime !== undefined) result.dinner_reminder_time = updates.dinnerReminderTime;
  if (updates.endOfDayReminderEnabled !== undefined) result.end_of_day_reminder_enabled = updates.endOfDayReminderEnabled;
  if (updates.endOfDayReminderTime !== undefined) result.end_of_day_reminder_time = updates.endOfDayReminderTime;
  return result;
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ userId: string }> }
) {
  try {
    const tokenUserId = getUserFromRequest(request);
    if (!tokenUserId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { userId } = await params;

    // Ensure user can only access their own data
    if (tokenUserId !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    const userRepo = await getRepository<User>(UserEntity);
    const user = await userRepo.findOne({ where: { id: userId } });

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(dumpUser(user));
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
    const tokenUserId = getUserFromRequest(request);
    if (!tokenUserId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { userId } = await params;

    // Ensure user can only update their own data
    if (tokenUserId !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

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

    return NextResponse.json(dumpUser(user));
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
