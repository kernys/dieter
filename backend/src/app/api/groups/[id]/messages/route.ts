import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { 
  GroupEntity, 
  GroupMemberEntity, 
  GroupMessageEntity, 
  MessageReactionEntity,
  UserEntity, 
  type Group, 
  type GroupMember, 
  type GroupMessage, 
  type MessageReaction,
  type User,
  type MessageReactionSummary,
  type GroupMessageResponse,
} from '@/entities';

const createMessageSchema = z.object({
  message: z.string().min(1).optional(),
  imageUrl: z.string().url().optional(),
  replyToId: z.string().uuid().optional(),
}).refine(data => data.message || data.imageUrl, {
  message: 'Either message or imageUrl is required',
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

    const reactionRepo = await getRepository<MessageReaction>(MessageReactionEntity);

    // Get messages (only top-level, not replies)
    const messages = await groupMessageRepo.find({
      where: { groupId: id, replyToId: null as unknown as string },
      order: { createdAt: 'ASC' },
    });

    // Fetch user details, reactions, and reply count for each message
    const messagesWithDetails = await Promise.all(
      messages.map(async (msg) => {
        const user = await userRepo.findOne({
          where: { id: msg.userId },
        });

        // Get reactions for this message
        const reactions = await reactionRepo.find({
          where: { messageId: msg.id },
        });

        // Aggregate reactions by emoji
        const reactionSummary: MessageReactionSummary[] = [];
        const emojiCounts = new Map<string, { count: number; userReacted: boolean }>();
        
        for (const reaction of reactions) {
          const existing = emojiCounts.get(reaction.emoji);
          if (existing) {
            existing.count++;
            if (reaction.userId === userId) existing.userReacted = true;
          } else {
            emojiCounts.set(reaction.emoji, { 
              count: 1, 
              userReacted: reaction.userId === userId 
            });
          }
        }
        
        emojiCounts.forEach((value, emoji) => {
          reactionSummary.push({ emoji, count: value.count, userReacted: value.userReacted });
        });

        // Count replies
        const replyCount = await groupMessageRepo.count({
          where: { replyToId: msg.id },
        });

        return {
          id: msg.id,
          groupId: msg.groupId,
          userId: msg.userId,
          userName: user?.name || 'Unknown',
          avatarUrl: user?.avatar_url,
          message: msg.message,
          imageUrl: msg.imageUrl,
          replyToId: msg.replyToId,
          reactions: reactionSummary,
          replyCount,
          createdAt: msg.createdAt,
        } as GroupMessageResponse;
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
      message: validatedData.message || '',
      imageUrl: validatedData.imageUrl || null,
      replyToId: validatedData.replyToId || null,
    });

    await groupMessageRepo.save(message);

    // Get user details
    const user = await userRepo.findOne({
      where: { id: userId },
    });

    // Get reply-to message if exists
    let replyTo: GroupMessageResponse | null = null;
    if (validatedData.replyToId) {
      const replyToMsg = await groupMessageRepo.findOne({
        where: { id: validatedData.replyToId },
      });
      if (replyToMsg) {
        const replyToUser = await userRepo.findOne({
          where: { id: replyToMsg.userId },
        });
        replyTo = {
          id: replyToMsg.id,
          groupId: replyToMsg.groupId,
          userId: replyToMsg.userId,
          userName: replyToUser?.name || 'Unknown',
          avatarUrl: replyToUser?.avatar_url,
          message: replyToMsg.message,
          imageUrl: replyToMsg.imageUrl,
          replyToId: replyToMsg.replyToId,
          reactions: [],
          replyCount: 0,
          createdAt: replyToMsg.createdAt,
        };
      }
    }

    return NextResponse.json({
      id: message.id,
      groupId: message.groupId,
      userId: message.userId,
      userName: user?.name || 'Unknown',
      avatarUrl: user?.avatar_url,
      message: message.message,
      imageUrl: message.imageUrl,
      replyToId: message.replyToId,
      replyTo,
      reactions: [],
      replyCount: 0,
      createdAt: message.createdAt,
    } as GroupMessageResponse, { status: 201 });
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
