import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { 
  GroupMemberEntity, 
  GroupMessageEntity, 
  MessageReactionEntity,
  type GroupMember, 
  type GroupMessage, 
  type MessageReaction,
} from '@/entities';

const reactionSchema = z.object({
  emoji: z.string().min(1).max(32),
});

// Add or toggle reaction
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string; messageId: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id: groupId, messageId } = await params;
    const body = await request.json();
    const { emoji } = reactionSchema.parse(body);

    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);
    const groupMessageRepo = await getRepository<GroupMessage>(GroupMessageEntity);
    const reactionRepo = await getRepository<MessageReaction>(MessageReactionEntity);

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId, userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Must be a member to react' },
        { status: 403 }
      );
    }

    // Check if message exists in this group
    const message = await groupMessageRepo.findOne({
      where: { id: messageId, groupId },
    });

    if (!message) {
      return NextResponse.json(
        { error: 'Message not found' },
        { status: 404 }
      );
    }

    // Check if user already reacted with this emoji
    const existingReaction = await reactionRepo.findOne({
      where: { messageId, userId, emoji },
    });

    if (existingReaction) {
      // Remove reaction (toggle off)
      await reactionRepo.remove(existingReaction);
      return NextResponse.json({ action: 'removed', emoji });
    } else {
      // Add reaction
      const reaction = reactionRepo.create({
        messageId,
        userId,
        emoji,
      });
      await reactionRepo.save(reaction);
      return NextResponse.json({ action: 'added', emoji, id: reaction.id }, { status: 201 });
    }
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.issues },
        { status: 400 }
      );
    }
    console.error('Reaction error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// Get reactions for a message
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string; messageId: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id: groupId, messageId } = await params;
    const groupMemberRepo = await getRepository<GroupMember>(GroupMemberEntity);
    const reactionRepo = await getRepository<MessageReaction>(MessageReactionEntity);

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId, userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Must be a member to view reactions' },
        { status: 403 }
      );
    }

    const reactions = await reactionRepo.find({
      where: { messageId },
    });

    // Aggregate by emoji
    const summary: { emoji: string; count: number; userReacted: boolean }[] = [];
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
      summary.push({ emoji, count: value.count, userReacted: value.userReacted });
    });

    return NextResponse.json({ reactions: summary });
  } catch (error) {
    console.error('Get reactions error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
