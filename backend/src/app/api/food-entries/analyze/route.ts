import { NextRequest, NextResponse } from 'next/server';
import { analyzeFood } from '@/lib/gemini';
import { getUserFromRequest } from '@/lib/auth';
import { del } from '@vercel/blob';
import { z } from 'zod';

const analyzeSchema = z.object({
  imageUrl: z.string().url(), // URL of the uploaded image
  locale: z.string().optional(), // User's locale for localized food names
});

export async function POST(request: NextRequest) {
  let imageUrl: string | null = null;

  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const body = await request.json();
    const parsed = analyzeSchema.parse(body);
    imageUrl = parsed.imageUrl;

    const result = await analyzeFood(imageUrl, parsed.locale);

    // Delete the temporary image after successful analysis
    try {
      await del(imageUrl);
    } catch (deleteError) {
      // Log but don't fail the request if deletion fails
      console.warn('Failed to delete temp image:', deleteError);
    }

    return NextResponse.json(result);
  } catch (error) {
    // Try to delete the image even if analysis fails
    if (imageUrl) {
      try {
        await del(imageUrl);
      } catch (deleteError) {
        console.warn('Failed to delete temp image on error:', deleteError);
      }
    }

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
