import { MigrationInterface, QueryRunner } from "typeorm";

export class AddGroupMessageFeatures1769600000000 implements MigrationInterface {
    name = 'AddGroupMessageFeatures1769600000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Add new columns to group_messages table
        await queryRunner.query(`
            ALTER TABLE "group_messages" 
            ADD COLUMN IF NOT EXISTS "image_url" TEXT
        `);
        
        await queryRunner.query(`
            ALTER TABLE "group_messages" 
            ADD COLUMN IF NOT EXISTS "reply_to_id" UUID REFERENCES "group_messages"("id") ON DELETE SET NULL
        `);
        
        // Create message_reactions table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "message_reactions" (
                "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                "message_id" UUID NOT NULL REFERENCES "group_messages"("id") ON DELETE CASCADE,
                "user_id" UUID NOT NULL REFERENCES "users"("id") ON DELETE CASCADE,
                "emoji" VARCHAR(32) NOT NULL,
                "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE("message_id", "user_id", "emoji")
            )
        `);
        
        // Create indexes for better performance
        await queryRunner.query(`
            CREATE INDEX IF NOT EXISTS "idx_message_reactions_message_id" ON "message_reactions"("message_id")
        `);
        
        await queryRunner.query(`
            CREATE INDEX IF NOT EXISTS "idx_group_messages_reply_to_id" ON "group_messages"("reply_to_id")
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop indexes
        await queryRunner.query(`DROP INDEX IF EXISTS "idx_group_messages_reply_to_id"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "idx_message_reactions_message_id"`);
        
        // Drop message_reactions table
        await queryRunner.query(`DROP TABLE IF EXISTS "message_reactions"`);
        
        // Remove columns from group_messages
        await queryRunner.query(`ALTER TABLE "group_messages" DROP COLUMN IF EXISTS "reply_to_id"`);
        await queryRunner.query(`ALTER TABLE "group_messages" DROP COLUMN IF EXISTS "image_url"`);
    }
}
