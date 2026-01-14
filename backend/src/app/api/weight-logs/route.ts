import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';

const createWeightLogSchema = z.object({
  user_id: z.string().uuid(),
  weight: z.number().positive(),
  note: z.string().optional(),
});

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('user_id');
    const limit = parseInt(searchParams.get('limit') || '100');
    const range = searchParams.get('range'); // 90d, 6m, 1y, all

    if (!userId) {
      return NextResponse.json(
        { error: 'user_id is required' },
        { status: 400 }
      );
    }

    let query = supabase
      .from('weight_logs')
      .select('*')
      .eq('user_id', userId)
      .order('logged_at', { ascending: false })
      .limit(limit);

    // Apply date range filter
    if (range && range !== 'all') {
      const now = new Date();
      let startDate: Date;

      switch (range) {
        case '90d':
          startDate = new Date(now.setDate(now.getDate() - 90));
          break;
        case '6m':
          startDate = new Date(now.setMonth(now.getMonth() - 6));
          break;
        case '1y':
          startDate = new Date(now.setFullYear(now.getFullYear() - 1));
          break;
        default:
          startDate = new Date(0);
      }

      query = query.gte('logged_at', startDate.toISOString());
    }

    const { data, error } = await query;

    if (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    // Calculate stats
    const weights = data.map(log => log.weight);
    const currentWeight = weights[0] || 0;
    const startWeight = weights[weights.length - 1] || currentWeight;
    const minWeight = Math.min(...weights);
    const maxWeight = Math.max(...weights);
    const avgWeight = weights.length > 0
      ? weights.reduce((a, b) => a + b, 0) / weights.length
      : 0;

    return NextResponse.json({
      logs: data,
      stats: {
        currentWeight,
        startWeight,
        minWeight,
        maxWeight,
        avgWeight,
        totalChange: currentWeight - startWeight,
        totalEntries: data.length,
      },
    });
  } catch (error) {
    console.error('Get weight logs error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = createWeightLogSchema.parse(body);

    const { data, error } = await supabase
      .from('weight_logs')
      .insert({
        id: uuidv4(),
        ...validatedData,
        logged_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (error) {
      return NextResponse.json(
        { error: error.message },
        { status: 400 }
      );
    }

    // Update user's current weight
    await supabase
      .from('users')
      .update({ current_weight: validatedData.weight })
      .eq('id', validatedData.user_id);

    return NextResponse.json(data, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.errors },
        { status: 400 }
      );
    }
    console.error('Create weight log error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
