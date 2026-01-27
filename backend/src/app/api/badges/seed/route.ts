import { NextRequest, NextResponse } from 'next/server';
import { seedDefaultBadges } from '@/lib/badge-service';

export const dynamic = 'force-dynamic';

// Seed default badges (admin only - should be called once)
export async function POST(request: NextRequest) {
  try {
    await seedDefaultBadges();
    return NextResponse.json({ success: true, message: 'Default badges seeded' });
  } catch (error) {
    console.error('Seed badges error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
