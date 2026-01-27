import { EntitySchema } from 'typeorm';

export interface Badge {
  id: string;
  name: string;
  description: string;
  iconUrl: string | null;
  category: string; // 'streak', 'food', 'exercise', 'weight', 'social'
  requirement: string; // JSON string with requirement details
  isHidden: boolean; // Hidden badges are only shown after earned
  createdAt: Date;
}

export interface BadgeResponse {
  id: string;
  name: string;
  description: string;
  iconUrl: string | null;
  category: string;
  requirement: object;
  isHidden: boolean;
  createdAt: Date;
}

export function dumpBadge(badge: Badge): BadgeResponse {
  return {
    id: badge.id,
    name: badge.name,
    description: badge.description,
    iconUrl: badge.iconUrl,
    category: badge.category,
    requirement: JSON.parse(badge.requirement || '{}'),
    isHidden: badge.isHidden,
    createdAt: badge.createdAt,
  };
}

export const BadgeEntity = new EntitySchema<Badge>({
  name: 'Badge',
  tableName: 'badges',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    name: {
      type: 'varchar',
      length: 100,
    },
    description: {
      type: 'text',
    },
    iconUrl: {
      name: 'icon_url',
      type: 'text',
      nullable: true,
    },
    category: {
      type: 'varchar',
      length: 50,
    },
    requirement: {
      type: 'text',
      default: '{}',
    },
    isHidden: {
      name: 'is_hidden',
      type: 'boolean',
      default: false,
    },
    createdAt: {
      name: 'created_at',
      type: 'timestamp',
      createDate: true,
    },
  },
});
