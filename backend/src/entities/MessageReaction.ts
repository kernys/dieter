import { EntitySchema } from 'typeorm';

export interface MessageReaction {
  id: string;
  messageId: string;
  userId: string;
  emoji: string;
  createdAt: Date;
}

export interface MessageReactionResponse {
  id: string;
  messageId: string;
  userId: string;
  emoji: string;
  createdAt: Date;
}

export function dumpMessageReaction(reaction: MessageReaction): MessageReactionResponse {
  return {
    id: reaction.id,
    messageId: reaction.messageId,
    userId: reaction.userId,
    emoji: reaction.emoji,
    createdAt: reaction.createdAt,
  };
}

export const MessageReactionEntity = new EntitySchema<MessageReaction>({
  name: 'MessageReaction',
  tableName: 'message_reactions',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    messageId: {
      name: 'message_id',
      type: 'uuid',
    },
    userId: {
      name: 'user_id',
      type: 'uuid',
    },
    emoji: {
      type: 'varchar',
      length: 32,
    },
    createdAt: {
      name: 'created_at',
      type: 'timestamp',
      createDate: true,
    },
  },
  indices: [
    {
      name: 'idx_message_reaction_unique',
      unique: true,
      columns: ['messageId', 'userId', 'emoji'],
    },
  ],
});
