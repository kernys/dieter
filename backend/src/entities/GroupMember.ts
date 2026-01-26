import { EntitySchema } from 'typeorm';

export interface GroupMember {
  id: string;
  groupId: string;
  userId: string;
  score: number;
  role: string;
  joinedAt: Date;
}

/** API response format for GroupMember (with user info) */
export interface GroupMemberResponse {
  id: string;
  groupId: string;
  userId: string;
  userName?: string;
  avatarUrl?: string | null;
  score: number;
  role: string;
  rank?: number;
  joinedAt: Date;
}

/** Convert GroupMember entity to API response format */
export function dumpGroupMember(
  member: GroupMember,
  extras?: { userName?: string; avatarUrl?: string | null; rank?: number }
): GroupMemberResponse {
  return {
    id: member.id,
    groupId: member.groupId,
    userId: member.userId,
    score: Number(member.score),
    role: member.role,
    joinedAt: member.joinedAt,
    ...extras,
  };
}

export const GroupMemberEntity = new EntitySchema<GroupMember>({
  name: 'GroupMember',
  tableName: 'group_members',
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
    score: {
      type: 'int',
      default: 0,
    },
    role: {
      type: 'varchar',
      default: 'member',
    },
    joinedAt: {
      name: 'joined_at',
      type: 'timestamp',
      createDate: true,
    },
  },
});
