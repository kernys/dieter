import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { FoodEntryEntity, type FoodEntry } from '@/entities';
import { MoreThanOrEqual } from 'typeorm';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('user_id');

    if (!userId) {
      return NextResponse.json(
        { error: 'user_id is required' },
        { status: 400 }
      );
    }

    const startDate = new Date();
    startDate.setDate(startDate.getDate() - 365);

    const foodEntryRepo = await getRepository<FoodEntry>(FoodEntryEntity);
    const entries = await foodEntryRepo.find({
      where: {
        user_id: userId,
        logged_at: MoreThanOrEqual(startDate),
      },
      select: ['logged_at'],
      order: { logged_at: 'DESC' },
    });

    const loggedDates = new Set(
      entries.map(entry => {
        const date = new Date(entry.logged_at);
        return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
      })
    );

    let currentStreak = 0;
    let maxStreak = 0;
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    for (let i = 0; i < 365; i++) {
      const checkDate = new Date(today);
      checkDate.setDate(checkDate.getDate() - i);
      const dateKey = `${checkDate.getFullYear()}-${checkDate.getMonth()}-${checkDate.getDate()}`;

      if (loggedDates.has(dateKey)) {
        currentStreak++;
      } else if (i === 0) {
        continue;
      } else {
        break;
      }
    }

    const weekData: boolean[] = [];
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay());

    for (let i = 0; i < 7; i++) {
      const checkDate = new Date(startOfWeek);
      checkDate.setDate(startOfWeek.getDate() + i);
      const dateKey = `${checkDate.getFullYear()}-${checkDate.getMonth()}-${checkDate.getDate()}`;
      weekData.push(loggedDates.has(dateKey));
    }

    const sortedDates = Array.from(loggedDates).sort();
    let tempStreak = 0;
    for (const dateStr of sortedDates) {
      tempStreak++;
      maxStreak = Math.max(maxStreak, tempStreak);
    }

    return NextResponse.json({
      currentStreak,
      maxStreak,
      weekData,
      totalDaysLogged: loggedDates.size,
    });
  } catch (error) {
    console.error('Get streak error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
