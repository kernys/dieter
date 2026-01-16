import { EntitySchema } from 'typeorm';

export interface User {
  id: string;
  email: string;
  password: string;
  name: string | null;
  avatar_url: string | null;
  daily_calorie_goal: number;
  daily_protein_goal: number;
  daily_carbs_goal: number;
  daily_fat_goal: number;
  current_weight: number | null;
  goal_weight: number | null;
  created_at: Date;
}

export const UserEntity = new EntitySchema<User>({
  name: 'User',
  tableName: 'users',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    email: {
      type: 'varchar',
      length: 255,
      unique: true,
    },
    password: {
      type: 'varchar',
      length: 255,
    },
    name: {
      type: 'varchar',
      length: 255,
      nullable: true,
    },
    avatar_url: {
      type: 'text',
      nullable: true,
    },
    daily_calorie_goal: {
      type: 'int',
      default: 2500,
    },
    daily_protein_goal: {
      type: 'int',
      default: 150,
    },
    daily_carbs_goal: {
      type: 'int',
      default: 275,
    },
    daily_fat_goal: {
      type: 'int',
      default: 70,
    },
    current_weight: {
      type: 'decimal',
      precision: 5,
      scale: 2,
      nullable: true,
    },
    goal_weight: {
      type: 'decimal',
      precision: 5,
      scale: 2,
      nullable: true,
    },
    created_at: {
      type: 'timestamp with time zone',
      createDate: true,
    },
  },
});
