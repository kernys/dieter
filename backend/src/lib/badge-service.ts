import { getRepository } from '@/lib/database';
import { 
  BadgeEntity, 
  UserBadgeEntity, 
  FoodEntryEntity,
  ExerciseEntryEntity,
  WeightLogEntity,
  type Badge, 
  type UserBadge,
  type FoodEntry,
  type ExerciseEntry,
  type WeightLog,
} from '@/entities';
import { Between, MoreThanOrEqual } from 'typeorm';

interface BadgeRequirement {
  type: 'streak' | 'food_logs' | 'exercise_logs' | 'weight_logs' | 'weight_loss' | 'calories';
  count?: number;
  days?: number;
  amount?: number;
}

// Check and award badges for a user
export async function checkAndAwardBadges(userId: string): Promise<string[]> {
  const badgeRepo = await getRepository<Badge>(BadgeEntity);
  const userBadgeRepo = await getRepository<UserBadge>(UserBadgeEntity);
  const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);
  const exerciseEntryRepo = await getRepository<ExerciseEntry>(ExerciseEntryEntity);
  const weightLogRepo = await getRepository<WeightLog>(WeightLogEntity);

  // Get all badges
  const allBadges = await badgeRepo.find();

  // Get user's already earned badges
  const earnedBadges = await userBadgeRepo.find({
    where: { userId },
  });
  const earnedBadgeIds = new Set(earnedBadges.map(eb => eb.badgeId));

  // Badges to check
  const unearned = allBadges.filter(b => !earnedBadgeIds.has(b.id));
  
  // Calculate user stats
  const now = new Date();
  const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
  
  // Get streak
  const streak = await calculateStreak(userId, foodEntryRepo, exerciseEntryRepo);
  
  // Get total food logs
  const totalFoodLogs = await foodEntryRepo.count({ where: { user_id: userId } as any });
  
  // Get total exercise logs
  const totalExerciseLogs = await exerciseEntryRepo.count({ where: { user_id: userId } as any });
  
  // Get total weight logs
  const totalWeightLogs = await weightLogRepo.count({ where: { user_id: userId } as any });
  
  // Get weight loss
  const weightLogs = await weightLogRepo.find({
    where: { user_id: userId } as any,
    order: { logged_at: 'ASC' } as any,
  });
  
  let weightLoss = 0;
  if (weightLogs.length >= 2) {
    const first = weightLogs[0].weight;
    const last = weightLogs[weightLogs.length - 1].weight;
    weightLoss = first - last; // Positive if lost weight
  }

  const newBadges: string[] = [];

  for (const badge of unearned) {
    const req: BadgeRequirement = JSON.parse(badge.requirement || '{}');
    let earned = false;
    let progress = 0;

    switch (req.type) {
      case 'streak':
        if (req.days && streak >= req.days) {
          earned = true;
        }
        progress = Math.min(100, Math.round((streak / (req.days || 1)) * 100));
        break;

      case 'food_logs':
        if (req.count && totalFoodLogs >= req.count) {
          earned = true;
        }
        progress = Math.min(100, Math.round((totalFoodLogs / (req.count || 1)) * 100));
        break;

      case 'exercise_logs':
        if (req.count && totalExerciseLogs >= req.count) {
          earned = true;
        }
        progress = Math.min(100, Math.round((totalExerciseLogs / (req.count || 1)) * 100));
        break;

      case 'weight_logs':
        if (req.count && totalWeightLogs >= req.count) {
          earned = true;
        }
        progress = Math.min(100, Math.round((totalWeightLogs / (req.count || 1)) * 100));
        break;

      case 'weight_loss':
        if (req.amount && weightLoss >= req.amount) {
          earned = true;
        }
        progress = Math.min(100, Math.round((weightLoss / (req.amount || 1)) * 100));
        break;
    }

    if (earned) {
      // Award badge
      const userBadge = userBadgeRepo.create({
        userId,
        badgeId: badge.id,
        progress: 100,
        isNew: true,
      });
      await userBadgeRepo.save(userBadge);
      newBadges.push(badge.id);
    }
  }

  return newBadges;
}

async function calculateStreak(
  userId: string, 
  foodEntryRepo: any, 
  exerciseEntryRepo: any
): Promise<number> {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  let streak = 0;
  let currentDate = new Date(today);

  while (true) {
    const dayStart = new Date(currentDate);
    dayStart.setHours(0, 0, 0, 0);
    const dayEnd = new Date(currentDate);
    dayEnd.setHours(23, 59, 59, 999);

    const hasFood = await foodEntryRepo.count({
      where: {
        user_id: userId,
        logged_at: Between(dayStart.toISOString(), dayEnd.toISOString()),
      } as any,
    });

    const hasExercise = await exerciseEntryRepo.count({
      where: {
        user_id: userId,
        logged_at: Between(dayStart.toISOString(), dayEnd.toISOString()),
      } as any,
    });

    if (hasFood > 0 || hasExercise > 0) {
      streak++;
      currentDate.setDate(currentDate.getDate() - 1);
    } else {
      // Allow skipping today if it's early
      if (streak === 0 && currentDate.getTime() === today.getTime()) {
        currentDate.setDate(currentDate.getDate() - 1);
        continue;
      }
      break;
    }
  }

  return streak;
}

// Seed default badges
export async function seedDefaultBadges(): Promise<void> {
  const badgeRepo = await getRepository<Badge>(BadgeEntity);
  
  const existingBadges = await badgeRepo.count();
  if (existingBadges > 0) return;

  const defaultBadges: Partial<Badge>[] = [
    // Streak badges
    {
      name: 'First Steps',
      description: 'Log your first day',
      category: 'streak',
      requirement: JSON.stringify({ type: 'streak', days: 1 }),
      isHidden: false,
    },
    {
      name: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      category: 'streak',
      requirement: JSON.stringify({ type: 'streak', days: 7 }),
      isHidden: false,
    },
    {
      name: 'Two Week Champion',
      description: 'Maintain a 14-day streak',
      category: 'streak',
      requirement: JSON.stringify({ type: 'streak', days: 14 }),
      isHidden: false,
    },
    {
      name: 'Monthly Master',
      description: 'Maintain a 30-day streak',
      category: 'streak',
      requirement: JSON.stringify({ type: 'streak', days: 30 }),
      isHidden: false,
    },
    {
      name: 'Streak Legend',
      description: 'Maintain a 100-day streak',
      category: 'streak',
      requirement: JSON.stringify({ type: 'streak', days: 100 }),
      isHidden: false,
    },

    // Food logging badges
    {
      name: 'Food Logger',
      description: 'Log 10 meals',
      category: 'food',
      requirement: JSON.stringify({ type: 'food_logs', count: 10 }),
      isHidden: false,
    },
    {
      name: 'Nutrition Tracker',
      description: 'Log 50 meals',
      category: 'food',
      requirement: JSON.stringify({ type: 'food_logs', count: 50 }),
      isHidden: false,
    },
    {
      name: 'Meal Master',
      description: 'Log 100 meals',
      category: 'food',
      requirement: JSON.stringify({ type: 'food_logs', count: 100 }),
      isHidden: false,
    },
    {
      name: 'Food Diary Expert',
      description: 'Log 500 meals',
      category: 'food',
      requirement: JSON.stringify({ type: 'food_logs', count: 500 }),
      isHidden: false,
    },

    // Exercise badges
    {
      name: 'Getting Active',
      description: 'Log 5 workouts',
      category: 'exercise',
      requirement: JSON.stringify({ type: 'exercise_logs', count: 5 }),
      isHidden: false,
    },
    {
      name: 'Fitness Enthusiast',
      description: 'Log 25 workouts',
      category: 'exercise',
      requirement: JSON.stringify({ type: 'exercise_logs', count: 25 }),
      isHidden: false,
    },
    {
      name: 'Exercise Champion',
      description: 'Log 100 workouts',
      category: 'exercise',
      requirement: JSON.stringify({ type: 'exercise_logs', count: 100 }),
      isHidden: false,
    },

    // Weight tracking badges
    {
      name: 'Scale Starter',
      description: 'Log your weight 5 times',
      category: 'weight',
      requirement: JSON.stringify({ type: 'weight_logs', count: 5 }),
      isHidden: false,
    },
    {
      name: 'Weight Watcher',
      description: 'Log your weight 20 times',
      category: 'weight',
      requirement: JSON.stringify({ type: 'weight_logs', count: 20 }),
      isHidden: false,
    },
    {
      name: 'First Kg Lost',
      description: 'Lose your first 1 kg',
      category: 'weight',
      requirement: JSON.stringify({ type: 'weight_loss', amount: 1 }),
      isHidden: false,
    },
    {
      name: '5 Kg Milestone',
      description: 'Lose 5 kg total',
      category: 'weight',
      requirement: JSON.stringify({ type: 'weight_loss', amount: 5 }),
      isHidden: false,
    },
    {
      name: '10 Kg Achievement',
      description: 'Lose 10 kg total',
      category: 'weight',
      requirement: JSON.stringify({ type: 'weight_loss', amount: 10 }),
      isHidden: false,
    },
  ];

  for (const badge of defaultBadges) {
    const newBadge = badgeRepo.create(badge);
    await badgeRepo.save(newBadge);
  }
}
