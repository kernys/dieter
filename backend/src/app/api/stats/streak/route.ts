import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

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

    // Get food entries for the last 365 days
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - 365);

    const { data: entries, error } = await supabase
      .from('food_entries')
      .select('logged_at')
      .eq('user_id', userId)
      .gte('logged_at', startDate.toISOString())
      .order('logged_at', { ascending: false });

    if (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    // Calculate streak
    const loggedDates = new Set(
      entries.map(entry => {
        const date = new Date(entry.logged_at);
        return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
      })
    );

    let currentStreak = 0;
    let maxStreak = 0;
    let tempStreak = 0;
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Calculate current streak (consecutive days from today going backwards)
    for (let i = 0; i < 365; i++) {
      const checkDate = new Date(today);
      checkDate.setDate(checkDate.getDate() - i);
      const dateKey = `${checkDate.getFullYear()}-${checkDate.getMonth()}-${checkDate.getDate()}`;

      if (loggedDates.has(dateKey)) {
        currentStreak++;
      } else if (i === 0) {
        // If no entry today, check if yesterday had entry
        continue;
      } else {
        break;
      }
    }

    // Calculate week data (S M T W T F S)
    const weekData: boolean[] = [];
    const startOfWeek = new Date(today);
    startOfWeek.setDate(today.getDate() - today.getDay()); // Start from Sunday

    for (let i = 0; i < 7; i++) {
      const checkDate = new Date(startOfWeek);
      checkDate.setDate(startOfWeek.getDate() + i);
      const dateKey = `${checkDate.getFullYear()}-${checkDate.getMonth()}-${checkDate.getDate()}`;
      weekData.push(loggedDates.has(dateKey));
    }

    // Calculate max streak
    const sortedDates = Array.from(loggedDates).sort();
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
