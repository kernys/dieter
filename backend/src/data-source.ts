import 'dotenv/config';
import { DataSource } from 'typeorm';
import { UserEntity, FoodEntryEntity, WeightLogEntity, GroupEntity, GroupMemberEntity, GroupMessageEntity } from './entities';

export const AppDataSource = new DataSource({
  type: 'postgres',
  url: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
  entities: [UserEntity, FoodEntryEntity, WeightLogEntity, GroupEntity, GroupMemberEntity, GroupMessageEntity],
  migrations: ['src/migrations/*.ts'],
  synchronize: false,
  logging: true,
});
