import { NextRequest, NextResponse } from 'next/server';
import { getRepository } from '@/lib/database';
import { WeightLogEntity, type WeightLog } from '@/entities';

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;

    const weightLogRepo = await getRepository<WeightLog>(WeightLogEntity);
    const weightLog = await weightLogRepo.findOne({ where: { id } });

    if (!weightLog) {
      return NextResponse.json(
        { error: 'Weight log not found' },
        { status: 404 }
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
