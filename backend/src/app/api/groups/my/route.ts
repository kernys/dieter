import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, type Group, type GroupMember } from '@/entities';

export async function GET(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const groupRepo = await getRepository<Group>(GroupEntity);
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);

    // Get user's group memberships
    const memberships = await groupMemberRepo.find({
      where: { userId: userId },
    });

    const groupIds = memberships.map(m => m.groupId);

    if (groupIds.length === 0) {
      return NextResponse.json({ groups: [] });
    }

    // Get the groups
    const groups = await Promise.all(
      groupIds.map(async (groupId) => {
        const group = await groupRepo.findOne({
          where: { id: groupId },
        });

        if (!group) return null;

        const memberCount = await groupMemberRepo.count({
          where: { groupId: groupId },
        });

        return {
          id: group.id,
          name: group.name,
          description: group.description,
          imageUrl: group.imageUrl,
          isPrivate: group.isPrivate,
          isMember: true,
          memberCount,
          createdAt: group.createdAt,
        };
      })
    );

    // Filter out null groups and sort by creation date
    const validGroups = groups
      .filter(g => g !== null)
      .sort((a, b) => new Date(b!.createdAt).getTime() - new Date(a!.createdAt).getTime());

    return NextResponse.json({ groups: validGroups });
  } catch (error) {
    console.error('Get my groups error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
