import { MigrationInterface, QueryRunner } from "typeorm";

export class AddBadgesFeature1769600001000 implements MigrationInterface {
    name = 'AddBadgesFeature1769600001000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create badges table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "badges" (
                "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                "name" VARCHAR(100) NOT NULL,
                "description" TEXT NOT NULL,
                "icon_url" TEXT,
                "category" VARCHAR(50) NOT NULL,
                "requirement" TEXT DEFAULT '{}',
                "is_hidden" BOOLEAN DEFAULT FALSE,
                "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);
        
        // Create user_badges table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "user_badges" (
                "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
                "badge_id" UUID NOT NULL REFERENCES "badges"("id") ON DELETE CASCADE,
                "earned_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                "progress" INTEGER DEFAULT 100,
                "is_new" BOOLEAN DEFAULT TRUE,
                UNIQUE("user_id", "badge_id")
            )
        `);
        
        // Create indexes
        await queryRunner.query(`
            CREATE INDEX IF NOT EXISTS "idx_user_badges_user_id" ON "user_badges"("user_id")
        `);
        
        await queryRunner.query(`
            CREATE INDEX IF NOT EXISTS "idx_badges_category" ON "badges"("category")
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS "idx_badges_category"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "idx_user_badges_user_id"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "user_badges"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "badges"`);
    }
}
