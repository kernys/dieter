import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { getUserFromRequest } from '@/lib/auth';
import { WeightLogEntity, type WeightLog } from '@/entities';

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = getUserFromRequest(request);
    if (!userId) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    const { id } = await params;

    const weightLogRepo = await getRepository<WeightLog>(WeightLogEntity);
    const weightLog = await weightLogRepo.findOne({ where: { id } });

    if (!weightLog) {
      return NextResponse.json(
        { error: 'Weight log not found' },
        { status: 404 }
      );
    }

    // Verify ownership
    if (weightLog.user_id !== userId) {
      return NextResponse.json(
        { error: 'Forbidden' },
        { status: 403 }
      );
    }

    await weightLogRepo.remove(weightLog);

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Delete weight log error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
