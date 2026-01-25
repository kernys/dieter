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
  height_feet: number | null;
  height_inches: number | null;
  height_cm: number | null;
  birth_date: Date | null;
  gender: string | null;
  daily_step_goal: number;
  onboarding_completed: boolean | null;
  // Notification settings
  breakfast_reminder_enabled: boolean;
  breakfast_reminder_time: string | null;
  lunch_reminder_enabled: boolean;
  lunch_reminder_time: string | null;
  snack_reminder_enabled: boolean;
  snack_reminder_time: string | null;
  dinner_reminder_enabled: boolean;
  dinner_reminder_time: string | null;
  end_of_day_reminder_enabled: boolean;
  end_of_day_reminder_time: string | null;
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
    height_feet: {
      type: 'decimal',
      precision: 3,
      scale: 1,
      nullable: true,
    },
    height_inches: {
      type: 'decimal',
      precision: 4,
      scale: 2,
      nullable: true,
    },
    height_cm: {
      type: 'decimal',
      precision: 5,
      scale: 2,
      nullable: true,
    },
    birth_date: {
      type: 'date',
      nullable: true,
    },
    gender: {
      type: 'varchar',
      length: 20,
      nullable: true,
    },
    daily_step_goal: {
      type: 'int',
      default: 10000,
    },
    onboarding_completed: {
      type: 'boolean',
      nullable: true,
    },
    // Notification settings
    breakfast_reminder_enabled: {
      type: 'boolean',
      default: true,
    },
    breakfast_reminder_time: {
      type: 'varchar',
      length: 5,
      nullable: true,
      default: '08:30',
    },
    lunch_reminder_enabled: {
      type: 'boolean',
      default: true,
    },
    lunch_reminder_time: {
      type: 'varchar',
      length: 5,
      nullable: true,
      default: '11:30',
    },
    snack_reminder_enabled: {
      type: 'boolean',
      default: false,
    },
    snack_reminder_time: {
      type: 'varchar',
      length: 5,
      nullable: true,
      default: '16:00',
    },
    dinner_reminder_enabled: {
      type: 'boolean',
      default: true,
    },
    dinner_reminder_time: {
      type: 'varchar',
      length: 5,
      nullable: true,
      default: '18:00',
    },
    end_of_day_reminder_enabled: {
      type: 'boolean',
      default: false,
    },
    end_of_day_reminder_time: {
      type: 'varchar',
      length: 5,
      nullable: true,
      default: '21:00',
    },
    created_at: {
      type: 'timestamp with time zone',
      createDate: true,
    },
  },
});
