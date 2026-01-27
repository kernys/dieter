import 'dotenv/config';
import { DataSource } from 'typeorm';
import { UserEntity, FoodEntryEntity, WeightLogEntity, GroupEntity, GroupMemberEntity, GroupMessageEntity, ExerciseEntryEntity, MessageReactionEntity, UserBadgeEntity, BadgeEntity } from './entities';

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
  entities: [
    UserEntity, 
    FoodEntryEntity, 
    ExerciseEntryEntity,
    WeightLogEntity,
    GroupEntity,
    GroupMemberEntity,
    GroupMessageEntity,
    MessageReactionEntity,
    BadgeEntity,
    UserBadgeEntity,
  ],
  migrations: ['src/migrations/*.ts'],
  synchronize: false,
  logging: true,
});
