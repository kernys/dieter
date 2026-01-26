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

/** API response format for Group */
export interface GroupResponse {
  id: string;
  name: string;
  description: string;
  imageUrl: string | null;
  isPrivate: boolean;
  createdById: string;
  createdAt: Date;
  updatedAt: Date;
  memberCount?: number;
  isMember?: boolean;
}

/** Convert Group entity to API response format */
export function dumpGroup(group: Group, extras?: { memberCount?: number; isMember?: boolean }): GroupResponse {
  return {
    id: group.id,
    name: group.name,
    description: group.description,
    imageUrl: group.imageUrl,
    isPrivate: group.isPrivate,
    createdById: group.createdById,
    createdAt: group.createdAt,
    updatedAt: group.updatedAt,
    ...extras,
  };
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
