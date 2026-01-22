import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { FoodEntryEntity, type FoodEntry } from '@/entities';
import { MoreThanOrEqual } from 'typeorm';

// Helper to get date in specific timezone
function getDateInTimezone(date: Date, offsetMinutes: number): Date {
  const utc = date.getTime() + (date.getTimezoneOffset() * 60000);
  return new Date(utc + (offsetMinutes * 60000));
}

// Format date as YYYY-MM-DD for comparison
function formatDateKey(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId');
    // Timezone offset in minutes (e.g., Asia/Seoul = +540)
    const tzOffset = parseInt(searchParams.get('tzOffset') || '0', 10);

    if (!userId) {
      return NextResponse.json(
        { error: 'userId is required' },
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

    // Convert dates to user's timezone
    const loggedDates = new Set(
      entries.map(entry => {
        const date = getDateInTimezone(new Date(entry.logged_at), tzOffset);
        return formatDateKey(date);
      })
    );

    let currentStreak = 0;
    let maxStreak = 0;
    const today = getDateInTimezone(new Date(), tzOffset);
    today.setHours(0, 0, 0, 0);

    for (let i = 0; i < 365; i++) {
      const checkDate = new Date(today);
      checkDate.setDate(checkDate.getDate() - i);
      const dateKey = formatDateKey(checkDate);

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
      const dateKey = formatDateKey(checkDate);
      weekData.push(loggedDates.has(dateKey));
    }

    // Calculate max streak by checking consecutive days
    const sortedDates = Array.from(loggedDates).sort();
    let tempStreak = 1;
    maxStreak = sortedDates.length > 0 ? 1 : 0;

    for (let i = 1; i < sortedDates.length; i++) {
      const [prevYear, prevMonth, prevDay] = sortedDates[i - 1].split('-').map(Number);
      const [currYear, currMonth, currDay] = sortedDates[i].split('-').map(Number);

      const prevDate = new Date(prevYear, prevMonth, prevDay);
      const currDate = new Date(currYear, currMonth, currDay);

      const diffDays = Math.round((currDate.getTime() - prevDate.getTime()) / (1000 * 60 * 60 * 24));

      if (diffDays === 1) {
        tempStreak++;
        maxStreak = Math.max(maxStreak, tempStreak);
      } else {
        tempStreak = 1;
      }
    }

    return NextResponse.json({
      currentStreak,
      maxStreak: Math.max(maxStreak, currentStreak),
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
