import { NextRequest, NextResponse } from 'next/server';
import { getUserFromRequest } from '@/lib/auth';
import { checkAndAwardBadges } from '@/lib/badge-service';
import { getRepository } from '@/lib/database';
import { BadgeEntity, type Badge, dumpBadge } from '@/entities';

export const dynamic = 'force-dynamic';

// Check and award any newly earned badges
export async function POST(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const newBadgeIds = await checkAndAwardBadges(userId);
    
    // Get full badge details for newly awarded badges
    const badgeRepo = await getRepository<Badge>(BadgeEntity);
    const newBadges = await Promise.all(
      newBadgeIds.map(async (id) => {
        const badge = await badgeRepo.findOne({ where: { id } });
        return badge ? dumpBadge(badge) : null;
      })
    );

    return NextResponse.json({
      newBadges: newBadges.filter(Boolean),
      count: newBadgeIds.length,
    });
  } catch (error) {
    console.error('Check badges error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
