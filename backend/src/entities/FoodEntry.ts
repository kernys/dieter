import { EntitySchema } from 'typeorm';

export interface FoodEntry {
  id: string;
  user_id: string;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  image_url: string | null;
  ingredients: object | null;
  servings: number;
  logged_at: Date;
}

/** API response format for FoodEntry */
export interface FoodEntryResponse {
  id: string;
  userId: string;
  name: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  imageUrl: string | null;
  ingredients: object | null;
  servings: number;
  loggedAt: Date;
}

/** Convert FoodEntry entity to API response format (camelCase) */
export function dumpFoodEntry(entry: FoodEntry): FoodEntryResponse {
  return {
    id: entry.id,
    userId: entry.user_id,
    name: entry.name,
    calories: Number(entry.calories),
    protein: Number(entry.protein),
    carbs: Number(entry.carbs),
    fat: Number(entry.fat),
    imageUrl: entry.image_url,
    ingredients: entry.ingredients,
    servings: Number(entry.servings),
    loggedAt: entry.logged_at,
  };
}

export const FoodEntryEntity = new EntitySchema<FoodEntry>({
  name: 'FoodEntry',
  tableName: 'food_entries',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    user_id: {
      type: 'uuid',
    },
    name: {
      type: 'varchar',
      length: 255,
    },
    calories: {
      type: 'decimal',
      precision: 10,
      scale: 2,
    },
    protein: {
      type: 'decimal',
      precision: 10,
      scale: 2,
    },
    carbs: {
      type: 'decimal',
      precision: 10,
      scale: 2,
    },
    fat: {
      type: 'decimal',
      precision: 10,
      scale: 2,
    },
    image_url: {
      type: 'text',
      nullable: true,
    },
    ingredients: {
      type: 'jsonb',
      nullable: true,
    },
    servings: {
      type: 'decimal',
      precision: 5,
      scale: 2,
      default: 1,
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
