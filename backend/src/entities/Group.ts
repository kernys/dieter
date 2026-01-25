import { EntitySchema } from 'typeorm';

export interface Group {
  id: string;
  name: string;
  description: string;
  imageUrl: string | null;
  isPrivate: boolean;
  createdById: string;
  createdAt: Date;
  updatedAt: Date;
}

export const GroupEntity = new EntitySchema<Group>({
  name: 'Group',
  tableName: 'groups',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    name: {
      type: 'varchar',
      length: 255,
    },
    description: {
      type: 'text',
    },
    imageUrl: {
      name: 'image_url',
      type: 'varchar',
      nullable: true,
    },
    isPrivate: {
      name: 'is_private',
      type: 'boolean',
      default: false,
    },
    createdById: {
      name: 'created_by_id',
      type: 'uuid',
    },
    createdAt: {
      name: 'created_at',
      type: 'timestamp',
      createDate: true,
    },
    updatedAt: {
      name: 'updated_at',
      type: 'timestamp',
      updateDate: true,
    },
  },
});
