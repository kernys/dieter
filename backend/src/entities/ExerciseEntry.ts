import { EntitySchema } from 'typeorm';

export interface ExerciseEntry {
  id: string;
  user_id: string;
  type: string;
  duration: number; // minutes
  calories_burned: number;
  intensity: string | null;
  description: string | null;
  logged_at: Date;
}

/** API response format for ExerciseEntry */
export interface ExerciseEntryResponse {
  id: string;
  userId: string;
  type: string;
  duration: number;
  caloriesBurned: number;
  intensity: string | null;
  description: string | null;
  loggedAt: Date;
}

/** Convert ExerciseEntry entity to API response format (camelCase) */
export function dumpExerciseEntry(entry: ExerciseEntry): ExerciseEntryResponse {
  return {
    id: entry.id,
    userId: entry.user_id,
    type: entry.type,
    duration: Number(entry.duration),
    caloriesBurned: Number(entry.calories_burned),
    intensity: entry.intensity,
    description: entry.description,
    loggedAt: entry.logged_at,
  };
}

export const ExerciseEntryEntity = new EntitySchema<ExerciseEntry>({
  name: 'ExerciseEntry',
  tableName: 'exercise_entries',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    user_id: {
      type: 'uuid',
    },
    type: {
      type: 'varchar',
      length: 255,
    },
    duration: {
      type: 'int',
      default: 0,
    },
    calories_burned: {
      type: 'int',
    },
    intensity: {
      type: 'varchar',
      length: 50,
      nullable: true,
    },
    description: {
      type: 'text',
      nullable: true,
    },
    logged_at: {
      type: 'timestamp with time zone',
      createDate: true,
    },
  },
  indices: [
    { columns: ['user_id'] },
    { columns: ['logged_at'] },
    { columns: ['user_id', 'logged_at'] },
  ],
});
