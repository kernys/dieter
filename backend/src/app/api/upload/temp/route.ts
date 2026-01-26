import { NextRequest, NextResponse } from 'next/server';
import { generateClientTokenFromReadWriteToken } from '@vercel/blob/client';
import { v4 as uuidv4 } from 'uuid';
import { getUserFromRequest } from '@/lib/auth';

/**
 * Generate a client upload token for temporary food analysis images.
 * Client will upload directly to Vercel Blob using this token.
 * Images should be deleted after analysis.
 */
export async function POST(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Generate unique pathname for this upload
    const filename = `temp-images/${uuidv4()}.jpg`;

    // Generate client token for direct upload to Vercel Blob
    const clientToken = await generateClientTokenFromReadWriteToken({
      pathname: filename,
      allowedContentTypes: ['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif'],
      maximumSizeInBytes: 100 * 1024 * 1024, // 100MB max
      validUntil: Date.now() + 30 * 60 * 1000, // Token valid for 30 minutes
    });

    return NextResponse.json({
      clientToken,
      pathname: filename,
    });
  } catch (error) {
    console.error('Generate upload token error:', error);
    return NextResponse.json(
      { error: 'Failed to generate upload token' },
      { status: 500 }
    );
  }
}
