import { EntitySchema } from 'typeorm';

export interface GroupMessage {
  id: string;
  groupId: string;
  userId: string;
  message: string;
  createdAt: Date;
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
