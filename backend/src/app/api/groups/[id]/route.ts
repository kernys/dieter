import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, type Group, type GroupMember } from '@/entities';

export async function GET(
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
    const groupRepo = await getRepository<Group>(GroupEntity);
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);

    const group = await groupRepo.findOne({
      where: { id },
    });

    if (!group) {
      return NextResponse.json(
        { error: 'Group not found' },
        { status: 404 }
      );
    }

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    // If group is private and user is not a member, deny access
    if (group.isPrivate && !membership) {
      return NextResponse.json(
        { error: 'Access denied' },
        { status: 403 }
      );
    }

    const memberCount = await groupMemberRepo.count({
      where: { groupId: id },
    });

    return NextResponse.json({
      id: group.id,
      name: group.name,
      description: group.description,
      imageUrl: group.imageUrl,
      isPrivate: group.isPrivate,
      isMember: !!membership,
      memberCount,
      createdAt: group.createdAt,
    });
  } catch (error) {
    console.error('Get group error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
