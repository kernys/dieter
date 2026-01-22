import { NextRequest, NextResponse } from 'next/server';
import { analyzeFood } from '@/lib/gemini';
import { getUserFromRequest } from '@/lib/auth';
import { z } from 'zod';

const analyzeSchema = z.object({
  image: z.string(), // Base64 encoded image
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
    const { image, locale } = analyzeSchema.parse(body);

    // Remove data URL prefix if present
    let imageBase64 = image;
    if (imageBase64.includes(',')) {
      imageBase64 = imageBase64.split(',')[1];
    }

    const result = await analyzeFood(imageBase64, locale);

    return NextResponse.json(result);
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Analyze food error:', error);
    return NextResponse.json(
      { error: 'Failed to analyze food image' },
      { status: 500 }
    );
  }
}
