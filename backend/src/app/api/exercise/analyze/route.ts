import { NextRequest, NextResponse } from 'next/server';
import { analyzeExercise } from '@/lib/gemini';
import { z } from 'zod';

const analyzeSchema = z.object({
  description: z.string().min(1, 'Description is required'),
  locale: z.string().optional(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { description, locale } = analyzeSchema.parse(body);

    const result = await analyzeExercise(description, locale);

    return NextResponse.json(result);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Analyze exercise error:', error);
    return NextResponse.json(
      { error: 'Failed to analyze exercise' },
      { status: 500 }
    );
  }
}
