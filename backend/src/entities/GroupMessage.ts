import { EntitySchema } from 'typeorm';

export interface GroupMessage {
  id: string;
  groupId: string;
  userId: string;
  message: string;
  createdAt: Date;
}

/** API response format for GroupMessage (with user info) */
export interface GroupMessageResponse {
  id: string;
  groupId: string;
  userId: string;
  userName?: string;
  avatarUrl?: string | null;
  message: string;
  createdAt: Date;
}

/** Convert GroupMessage entity to API response format */
export function dumpGroupMessage(
  msg: GroupMessage,
  extras?: { userName?: string; avatarUrl?: string | null }
): GroupMessageResponse {
  return {
    id: msg.id,
    groupId: msg.groupId,
    userId: msg.userId,
    message: msg.message,
    createdAt: msg.createdAt,
    ...extras,
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
    createdAt: {
      name: 'created_at',
      type: 'timestamp',
      createDate: true,
    },
  },
});
