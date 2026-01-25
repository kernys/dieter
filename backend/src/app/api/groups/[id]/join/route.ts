import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, type Group, type GroupMember } from '@/entities';

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

    const { id } = await params;
    const groupRepo = await getRepository<Group>(GroupEntity);
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);

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

    // Check if already a member
    const existingMembership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    if (existingMembership) {
      return NextResponse.json(
        { error: 'Already a member' },
        { status: 400 }
      );
    }

    // Create membership
    const member = groupMemberRepo.create({
      groupId: id,
      userId: userId,
      role: 'member',
      score: 0,
    });

    await groupMemberRepo.save(member);

    return NextResponse.json({
      success: true,
      message: 'Joined group successfully',
    });
  } catch (error) {
    console.error('Join group error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
