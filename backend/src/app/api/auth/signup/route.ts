import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { hashPassword, generateToken } from '@/lib/auth';
import { UserEntity, type User } from '@/entities';

const signupSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  name: z.string().optional(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { email, password, name } = signupSchema.parse(body);

    const userRepo = await getRepository<User>(UserEntity);

    const existingUser = await userRepo.findOne({ where: { email } });
    if (existingUser) {
      return NextResponse.json(
        { error: 'Email already registered' },
        { status: 400 }
      );
    }

    const hashedPassword = await hashPassword(password);

    const user = userRepo.create({
      email,
      password: hashedPassword,
      name: name || null,
      daily_calorie_goal: 2500,
      daily_protein_goal: 150,
      daily_carbs_goal: 275,
      daily_fat_goal: 70,
    });

    await userRepo.save(user);

    const token = generateToken(user.id, user.email);

    return NextResponse.json({
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
      },
      session: {
        accessToken: token,
        expiresAt: Math.floor(Date.now() / 1000) + 7 * 24 * 60 * 60,
      },
      message: 'Signup successful',
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Signup error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
