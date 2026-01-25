import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupMemberEntity, type GroupMember } from '@/entities';

export async function DELETE(
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

    const { id } = await params;
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);

    // Find the membership
    const membership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Not a member of this group' },
        { status: 400 }
      );
    }

    // Delete the membership
    await groupMemberRepo.remove(membership);

    return NextResponse.json({
      success: true,
      message: 'Left group successfully',
    });
  } catch (error) {
    console.error('Leave group error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
