import { EntitySchema } from 'typeorm';

export interface GroupMember {
  id: string;
  groupId: string;
  userId: string;
  score: number;
  role: string;
  joinedAt: Date;
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
