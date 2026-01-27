import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { UserBadgeEntity, type UserBadge } from '@/entities';

// Mark badge as seen
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id: badgeId } = await params;
    const userBadgeRepo = await getRepository<UserBadge>(UserBadgeEntity);

    const userBadge = await userBadgeRepo.findOne({
      where: { userId, badgeId },
    });

    if (!userBadge) {
      return NextResponse.json(
        { error: 'Badge not found' },
        { status: 404 }
      );
    }

    userBadge.isNew = false;
    await userBadgeRepo.save(userBadge);

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Mark badge seen error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
