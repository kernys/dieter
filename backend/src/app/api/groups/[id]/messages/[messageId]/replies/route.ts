import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { 
  GroupMemberEntity, 
  GroupMessageEntity, 
  MessageReactionEntity,
  UserEntity,
  type GroupMember, 
  type GroupMessage, 
  type MessageReaction,
  type User,
  type MessageReactionSummary,
  type GroupMessageResponse,
} from '@/entities';

// Get replies to a message
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
    const groupMessageRepo = await getRepository<GroupMessage>(GroupMessageEntity);
    const reactionRepo = await getRepository<MessageReaction>(MessageReactionEntity);
    const userRepo = await getRepository<User>(UserEntity);

    // Check if user is a member
    const membership = await groupMemberRepo.findOne({
      where: { groupId, userId },
    });

    if (!membership) {
      return NextResponse.json(
        { error: 'Must be a member to view replies' },
        { status: 403 }
      );
    }

    // Get replies
    const replies = await groupMessageRepo.find({
      where: { replyToId: messageId },
      order: { createdAt: 'ASC' },
    });

    // Fetch user details and reactions for each reply
    const repliesWithDetails = await Promise.all(
      replies.map(async (msg) => {
        const user = await userRepo.findOne({
          where: { id: msg.userId },
        });

        // Get reactions
        const reactions = await reactionRepo.find({
          where: { messageId: msg.id },
        });

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
          replyCount: 0,
          createdAt: msg.createdAt,
        } as GroupMessageResponse;
      })
    );

    return NextResponse.json({ replies: repliesWithDetails });
  } catch (error) {
    console.error('Get replies error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
