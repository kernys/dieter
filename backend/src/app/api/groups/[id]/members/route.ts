import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, UserEntity, type Group, type GroupMember, type User } from '@/entities';

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
    const userRepo = await getRepository<User>(UserEntity);

    // Check if group exists
    const group = await groupRepo.findOne({
      where: { id },
    });

    if (!group) {
      return NextResponse.json(
        { error: 'Group not found' },
        { status: 404 }
      );
    }

    // Check if user is a member (required for private groups)
    const userMembership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    if (group.isPrivate && !userMembership) {
      return NextResponse.json(
        { error: 'Access denied' },
        { status: 403 }
      );
    }

    // Get all members
    const members = await groupMemberRepo.find({
      where: { groupId: id },
      order: { score: 'DESC' },
    });

    // Fetch user details for each member
    const membersWithDetails = await Promise.all(
      members.map(async (member, index) => {
        const user = await userRepo.findOne({
          where: { id: member.userId },
        });

        return {
          id: member.id,
          userId: member.userId,
          userName: user?.name || 'Unknown',
          avatarUrl: user?.avatar_url,
          score: member.score,
          rank: index + 1,
          role: member.role,
          joinedAt: member.joinedAt,
        };
      })
    );

    return NextResponse.json({ members: membersWithDetails });
  } catch (error) {
    console.error('Get group members error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
