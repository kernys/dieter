import { EntitySchema } from 'typeorm';

export interface User {
  id: string;
  email: string;
  password: string;
  name: string | null;
  avatar_url: string | null;
  role_model_image_url: string | null;
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

/** API response format for User (excludes password) */
export interface UserResponse {
  id: string;
  email: string;
  name: string | null;
  avatarUrl: string | null;
  roleModelImageUrl: string | null;
  dailyCalorieGoal: number;
  dailyProteinGoal: number;
  dailyCarbsGoal: number;
  dailyFatGoal: number;
  currentWeight: number | null;
  goalWeight: number | null;
  heightFeet: number | null;
  heightInches: number | null;
  heightCm: number | null;
  birthDate: string | null; // YYYY-MM-DD format
  gender: string | null;
  dailyStepGoal: number;
  onboardingCompleted: boolean | null;
  breakfastReminderEnabled: boolean;
  breakfastReminderTime: string | null;
  lunchReminderEnabled: boolean;
  lunchReminderTime: string | null;
  snackReminderEnabled: boolean;
  snackReminderTime: string | null;
  dinnerReminderEnabled: boolean;
  dinnerReminderTime: string | null;
  endOfDayReminderEnabled: boolean;
  endOfDayReminderTime: string | null;
  createdAt: Date;
}

/** Format birth_date from DB (can be Date, string, or null) to YYYY-MM-DD */
function formatBirthDate(birthDate: Date | string | null | undefined): string | null {
  if (!birthDate) return null;
  try {
    if (typeof birthDate === 'string') {
      return birthDate.split('T')[0];
    }
    if (birthDate instanceof Date && !isNaN(birthDate.getTime())) {
      return birthDate.toISOString().split('T')[0];
    }
    return String(birthDate).split('T')[0];
  } catch {
    return null;
  }
}

/** Convert User entity to API response format (camelCase, excludes password) */
export function dumpUser(user: User): UserResponse {
  return {
    id: user.id,
    email: user.email,
    name: user.name,
    avatarUrl: user.avatar_url,
    roleModelImageUrl: user.role_model_image_url,
    dailyCalorieGoal: Number(user.daily_calorie_goal),
    dailyProteinGoal: Number(user.daily_protein_goal),
    dailyCarbsGoal: Number(user.daily_carbs_goal),
    dailyFatGoal: Number(user.daily_fat_goal),
    currentWeight: user.current_weight ? Number(user.current_weight) : null,
    goalWeight: user.goal_weight ? Number(user.goal_weight) : null,
    heightFeet: user.height_feet ? Number(user.height_feet) : null,
    heightInches: user.height_inches ? Number(user.height_inches) : null,
    heightCm: user.height_cm ? Number(user.height_cm) : null,
    birthDate: formatBirthDate(user.birth_date as Date | string | null),
    gender: user.gender,
    dailyStepGoal: Number(user.daily_step_goal ?? 10000),
    onboardingCompleted: user.onboarding_completed,
    breakfastReminderEnabled: user.breakfast_reminder_enabled ?? true,
    breakfastReminderTime: user.breakfast_reminder_time ?? '08:30',
    lunchReminderEnabled: user.lunch_reminder_enabled ?? true,
    lunchReminderTime: user.lunch_reminder_time ?? '11:30',
    snackReminderEnabled: user.snack_reminder_enabled ?? false,
    snackReminderTime: user.snack_reminder_time ?? '16:00',
    dinnerReminderEnabled: user.dinner_reminder_enabled ?? true,
    dinnerReminderTime: user.dinner_reminder_time ?? '18:00',
    endOfDayReminderEnabled: user.end_of_day_reminder_enabled ?? false,
    endOfDayReminderTime: user.end_of_day_reminder_time ?? '21:00',
    createdAt: user.created_at,
  };
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
    role_model_image_url: {
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
