import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { comparePassword, generateToken } from '@/lib/auth';
import { UserEntity, type User } from '@/entities';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password } = loginSchema.parse(body);

    const userRepo = await getRepository<User>(UserEntity);
    const user = await userRepo.findOne({ where: { email } });

    if (!user) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
      );
    }

    const isValidPassword = await comparePassword(password, user.password);
    if (!isValidPassword) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
      );
    }

    const token = generateToken(user.id, user.email);

    return NextResponse.json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        avatar_url: user.avatar_url,
        daily_calorie_goal: user.daily_calorie_goal,
        daily_protein_goal: user.daily_protein_goal,
        daily_carbs_goal: user.daily_carbs_goal,
        daily_fat_goal: user.daily_fat_goal,
        current_weight: user.current_weight,
        goal_weight: user.goal_weight,
      },
      session: {
        accessToken: token,
        expiresAt: null, // Token does not expire
      },
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Login error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
