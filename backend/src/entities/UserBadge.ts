import { EntitySchema } from 'typeorm';

export interface UserBadge {
  id: string;
  userId: string;
  badgeId: string;
  earnedAt: Date;
  progress: number; // 0-100 progress percentage for in-progress badges
  isNew: boolean; // Whether the user has seen this badge
}

export interface UserBadgeResponse {
  id: string;
  userId: string;
  badgeId: string;
  earnedAt: Date;
  progress: number;
  isNew: boolean;
}

export function dumpUserBadge(userBadge: UserBadge): UserBadgeResponse {
  return {
    id: userBadge.id,
    userId: userBadge.userId,
    badgeId: userBadge.badgeId,
    earnedAt: userBadge.earnedAt,
    progress: userBadge.progress,
    isNew: userBadge.isNew,
  };
}

export const UserBadgeEntity = new EntitySchema<UserBadge>({
  name: 'UserBadge',
  tableName: 'user_badges',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    userId: {
      name: 'user_id',
      type: 'uuid',
    },
    badgeId: {
      name: 'badge_id',
      type: 'uuid',
    },
    earnedAt: {
      name: 'earned_at',
      type: 'timestamp',
      createDate: true,
    },
    progress: {
      type: 'integer',
      default: 100,
    },
    isNew: {
      name: 'is_new',
      type: 'boolean',
      default: true,
    },
  },
  indices: [
    {
      name: 'idx_user_badge_unique',
      unique: true,
      columns: ['userId', 'badgeId'],
    },
  ],
});
