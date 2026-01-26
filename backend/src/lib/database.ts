import { DataSource, EntitySchema, Repository } from 'typeorm';
import { 
  UserEntity, 
  FoodEntryEntity, 
  WeightLogEntity,
  GroupEntity,
  GroupMemberEntity,
  GroupMessageEntity,
} from '@/entities';
import pg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

// Parse PostgreSQL numeric/decimal as JavaScript number instead of string
pg.types.setTypeParser(1700, (val) => parseFloat(val));

let dataSource: DataSource | null = null;

export async function getDataSource(): Promise<DataSource> {
  if (dataSource && dataSource.isInitialized) {
    return dataSource;
  }

  dataSource = new DataSource({
    type: 'postgres',
    url: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false,
    },
    entities: [
      UserEntity, 
      FoodEntryEntity, 
      WeightLogEntity,
      GroupEntity,
      GroupMemberEntity,
      GroupMessageEntity,
    ],
    synchronize: false,
    logging: process.env.NODE_ENV === 'development',
  });

  await dataSource.initialize();
  return dataSource;
}

export async function getRepository<T extends object>(entity: EntitySchema<T>): Promise<Repository<T>> {
  const ds = await getDataSource();
  return ds.getRepository<T>(entity);
}

// For raw queries if needed
export async function query<T = unknown>(text: string, params?: unknown[]): Promise<T[]> {
  const ds = await getDataSource();
  const result = await ds.query(text, params);
  return result as T[];
}

export async function queryOne<T = unknown>(text: string, params?: unknown[]): Promise<T | null> {
  const ds = await getDataSource();
  const result = await ds.query(text, params);
  return (result[0] as T) || null;
}
