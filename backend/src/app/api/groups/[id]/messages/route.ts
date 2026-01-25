import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { GroupEntity, GroupMemberEntity, GroupMessageEntity, UserEntity, type Group, type GroupMember, type GroupMessage, type User } from '@/entities';

const createMessageSchema = z.object({
  message: z.string().min(1),
});

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
    const groupMessageRepo = await getRepository<GroupMessage>(GroupMessageEntity);
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

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Must be a member to view messages' },
        { status: 403 }
      );
    }

    // Get messages
    const messages = await groupMessageRepo.find({
      where: { groupId: id },
      order: { createdAt: 'ASC' },
    });

    // Fetch user details for each message
    const messagesWithDetails = await Promise.all(
      messages.map(async (msg) => {
        const user = await userRepo.findOne({
          where: { id: msg.userId },
        });

        return {
          id: msg.id,
          groupId: msg.groupId,
          userId: msg.userId,
          userName: user?.name || 'Unknown',
          avatarUrl: user?.avatar_url,
          message: msg.message,
          createdAt: msg.createdAt,
        };
      })
    );

    return NextResponse.json({ messages: messagesWithDetails });
  } catch (error) {
    console.error('Get group messages error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

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
    const body = await request.json();
    const validatedData = createMessageSchema.parse(body);

    const groupRepo = await getRepository<Group>(GroupEntity);
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);
    const groupMessageRepo = await getRepository<GroupMessage>(GroupMessageEntity);
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

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId: id, userId: userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Must be a member to send messages' },
        { status: 403 }
      );
    }

    // Create message
    const message = groupMessageRepo.create({
      groupId: id,
      userId: userId,
      message: validatedData.message,
    });

    await groupMessageRepo.save(message);

    // Get user details
    const user = await userRepo.findOne({
      where: { id: userId },
    });

    return NextResponse.json({
      id: message.id,
      groupId: message.groupId,
      userId: message.userId,
      userName: user?.name || 'Unknown',
      avatarUrl: user?.avatar_url,
      message: message.message,
      createdAt: message.createdAt,
    }, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Create group message error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
