import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, type Group, type GroupMember } from '@/entities';

const createGroupSchema = z.object({
  name: z.string().min(1),
  description: z.string(),
  imageUrl: z.string().nullish(),
  isPrivate: z.boolean().default(false),
});

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

    // Get all public groups or private groups user is a member of
    const allGroups = await groupRepo.find({
      order: { createdAt: 'DESC' },
    });

    // Get user's memberships
    const userMemberships = await groupMemberRepo.find({
      where: { userId: userId },
    });

    const membershipMap = new Map(
      userMemberships.map(m => [m.groupId, true])
    );

    // Count members for each group
    const groups = await Promise.all(
      allGroups
        .filter(group => !group.isPrivate || membershipMap.has(group.id))
        .map(async (group) => {
          const memberCount = await groupMemberRepo.count({
            where: { groupId: group.id },
          });

          return {
            id: group.id,
            name: group.name,
            description: group.description,
            imageUrl: group.imageUrl,
            isPrivate: group.isPrivate,
            isMember: membershipMap.has(group.id),
            memberCount,
            createdAt: group.createdAt,
          };
        })
    );

    return NextResponse.json({ groups });
  } catch (error) {
    console.error('Get groups error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const body = await request.json();
    const validatedData = createGroupSchema.parse(body);

    const groupRepo = await getRepository<Group>(GroupEntity);
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);

    // Create the group
    const group = groupRepo.create({
      name: validatedData.name,
      description: validatedData.description,
      imageUrl: validatedData.imageUrl,
      isPrivate: validatedData.isPrivate,
      createdById: userId,
    });

    await groupRepo.save(group);

    // Add creator as admin member
    const member = groupMemberRepo.create({
      groupId: group.id,
      userId: userId,
      role: 'admin',
      score: 0,
    });

    await groupMemberRepo.save(member);

    return NextResponse.json({
      id: group.id,
      name: group.name,
      description: group.description,
      imageUrl: group.imageUrl,
      isPrivate: group.isPrivate,
      isMember: true,
      memberCount: 1,
      createdAt: group.createdAt,
    }, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Create group error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
