import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { 
  BadgeEntity, 
  UserBadgeEntity, 
  type Badge, 
  type UserBadge,
  dumpBadge 
} from '@/entities';

export const dynamic = 'force-dynamic';

// Get all badges with user progress
export async function GET(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const badgeRepo = await getRepository<Badge>(BadgeEntity);
    const userBadgeRepo = await getRepository<UserBadge>(UserBadgeEntity);

    // Get all badges
    const allBadges = await badgeRepo.find({
      order: { category: 'ASC', name: 'ASC' },
    });

    // Get user's earned badges
    const userBadges = await userBadgeRepo.find({
      where: { userId },
    });

    const userBadgeMap = new Map<string, UserBadge>();
    for (const ub of userBadges) {
      userBadgeMap.set(ub.badgeId, ub);
    }

    // Combine badges with user progress
    const badgesWithProgress = allBadges
      .filter(badge => !badge.isHidden || userBadgeMap.has(badge.id))
      .map(badge => {
        const userBadge = userBadgeMap.get(badge.id);
        return {
          ...dumpBadge(badge),
          earned: !!userBadge,
          earnedAt: userBadge?.earnedAt || null,
          progress: userBadge?.progress || 0,
          isNew: userBadge?.isNew || false,
        };
      });

    // Count stats
    const totalBadges = badgesWithProgress.length;
    const earnedBadges = badgesWithProgress.filter(b => b.earned).length;
    const newBadges = badgesWithProgress.filter(b => b.isNew).length;

    return NextResponse.json({
      badges: badgesWithProgress,
      stats: {
        total: totalBadges,
        earned: earnedBadges,
        newBadges,
      },
    });
  } catch (error) {
    console.error('Get badges error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
