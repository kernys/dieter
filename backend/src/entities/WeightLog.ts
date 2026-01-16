import { EntitySchema } from 'typeorm';

export interface WeightLog {
  id: string;
  user_id: string;
  weight: number;
  note: string | null;
  logged_at: Date;
}

export const WeightLogEntity = new EntitySchema<WeightLog>({
  name: 'WeightLog',
  tableName: 'weight_logs',
  columns: {
    id: {
      type: 'uuid',
      primary: true,
      generated: 'uuid',
    },
    user_id: {
      type: 'uuid',
    },
    weight: {
      type: 'decimal',
      precision: 5,
      scale: 2,
    },
    note: {
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
