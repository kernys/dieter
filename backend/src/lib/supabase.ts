import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL!;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;

export const supabase = createClient(supabaseUrl, supabaseServiceKey);

export type Database = {
  public: {
    Tables: {
      users: {
        Row: {
          id: string;
          email: string;
          name: string | null;
          avatar_url: string | null;
          daily_calorie_goal: number;
          daily_protein_goal: number;
          daily_carbs_goal: number;
          daily_fat_goal: number;
          current_weight: number | null;
          goal_weight: number | null;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['users']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['users']['Insert']>;
      };
      food_entries: {
        Row: {
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
          logged_at: string;
        };
        Insert: Omit<Database['public']['Tables']['food_entries']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['food_entries']['Insert']>;
      };
      weight_logs: {
        Row: {
          id: string;
          user_id: string;
          weight: number;
          note: string | null;
          logged_at: string;
        };
        Insert: Omit<Database['public']['Tables']['weight_logs']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['weight_logs']['Insert']>;
      };
    };
  };
};
