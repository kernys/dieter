import { NextRequest, NextResponse } from 'next/server';
import { analyzeTextFood } from '@/lib/gemini';
import { getUserFromRequest } from '@/lib/auth';
import { z } from 'zod';

const analyzeSchema = z.object({
  description: z.string(), // Text description of food
  locale: z.string().optional(), // User's locale for localized food names
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
    const { description, locale } = analyzeSchema.parse(body);

    const result = await analyzeTextFood(description, locale);

    return NextResponse.json(result);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Analyze text food error:', error);
    return NextResponse.json(
      { error: 'Failed to analyze food description' },
      { status: 500 }
    );
  }
}
