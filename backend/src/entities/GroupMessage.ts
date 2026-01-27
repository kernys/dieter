import { EntitySchema } from 'typeorm';

export interface GroupMessage {
  id: string;
  groupId: string;
  userId: string;
  message: string;
  imageUrl: string | null;
  replyToId: string | null;
  createdAt: Date;
}

/** API response format for GroupMessage (with user info and reactions) */
export interface GroupMessageResponse {
  id: string;
  groupId: string;
  userId: string;
  userName?: string;
  avatarUrl?: string | null;
  message: string;
  imageUrl?: string | null;
  replyToId?: string | null;
  replyTo?: GroupMessageResponse | null;
  reactions: MessageReactionSummary[];
  replyCount: number;
  createdAt: Date;
}

export interface MessageReactionSummary {
  emoji: string;
  count: number;
  userReacted: boolean;
}

/** Convert GroupMessage entity to API response format */
export function dumpGroupMessage(
  msg: GroupMessage,
  extras?: { 
    userName?: string; 
    avatarUrl?: string | null;
    reactions?: MessageReactionSummary[];
    replyTo?: GroupMessageResponse | null;
    replyCount?: number;
  }
): GroupMessageResponse {
  return {
    id: msg.id,
    groupId: msg.groupId,
    userId: msg.userId,
    message: msg.message,
    imageUrl: msg.imageUrl,
    replyToId: msg.replyToId,
    createdAt: msg.createdAt,
    reactions: extras?.reactions || [],
    replyCount: extras?.replyCount || 0,
    replyTo: extras?.replyTo || null,
    userName: extras?.userName,
    avatarUrl: extras?.avatarUrl,
  };
}

export const GroupMessageEntity = new EntitySchema<GroupMessage>({
  name: 'GroupMessage',
  tableName: 'group_messages',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    groupId: {
      name: 'group_id',
      type: 'uuid',
    },
    userId: {
      name: 'user_id',
      type: 'uuid',
    },
    message: {
      type: 'text',
    },
    imageUrl: {
      name: 'image_url',
      type: 'text',
      nullable: true,
    },
    replyToId: {
      name: 'reply_to_id',
      type: 'uuid',
      nullable: true,
    },
    createdAt: {
      name: 'created_at',
      type: 'timestamp',
      createDate: true,
    },
  },
});
