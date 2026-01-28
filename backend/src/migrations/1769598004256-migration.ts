import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1769598004256 implements MigrationInterface {
    name = 'Migration1769598004256'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "group_messages" DROP CONSTRAINT "group_messages_reply_to_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "message_reactions" DROP CONSTRAINT "message_reactions_message_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "message_reactions" DROP CONSTRAINT "message_reactions_user_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "user_badges" DROP CONSTRAINT "user_badges_user_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "user_badges" DROP CONSTRAINT "user_badges_badge_id_fkey"`);
        await queryRunner.query(`DROP INDEX "public"."idx_group_messages_reply_to_id"`);
        await queryRunner.query(`DROP INDEX "public"."idx_message_reactions_message_id"`);
        await queryRunner.query(`DROP INDEX "public"."idx_badges_category"`);
        await queryRunner.query(`DROP INDEX "public"."idx_user_badges_user_id"`);
        await queryRunner.query(`ALTER TABLE "message_reactions" DROP CONSTRAINT "message_reactions_message_id_user_id_emoji_key"`);
        await queryRunner.query(`ALTER TABLE "user_badges" DROP CONSTRAINT "user_badges_user_id_badge_id_key"`);
        await queryRunner.query(`ALTER TABLE "users" ADD "role_model_image_url" text`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ALTER COLUMN "created_at" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ALTER COLUMN "created_at" SET DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "requirement" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "is_hidden" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "created_at" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "created_at" SET DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "earned_at" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "earned_at" SET DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "progress" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "is_new" SET NOT NULL`);
        await queryRunner.query(`CREATE UNIQUE INDEX "idx_message_reaction_unique" ON "message_reactions" ("message_id", "user_id", "emoji") `);
        await queryRunner.query(`CREATE UNIQUE INDEX "idx_user_badge_unique" ON "user_badges" ("user_id", "badge_id") `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX "public"."idx_user_badge_unique"`);
        await queryRunner.query(`DROP INDEX "public"."idx_message_reaction_unique"`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "is_new" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "progress" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "earned_at" SET DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "user_badges" ALTER COLUMN "earned_at" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "created_at" SET DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "created_at" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "is_hidden" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "badges" ALTER COLUMN "requirement" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ALTER COLUMN "created_at" SET DEFAULT CURRENT_TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ALTER COLUMN "created_at" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "role_model_image_url"`);
        await queryRunner.query(`ALTER TABLE "user_badges" ADD CONSTRAINT "user_badges_user_id_badge_id_key" UNIQUE ("user_id", "badge_id")`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ADD CONSTRAINT "message_reactions_message_id_user_id_emoji_key" UNIQUE ("message_id", "user_id", "emoji")`);
        await queryRunner.query(`CREATE INDEX "idx_user_badges_user_id" ON "user_badges" ("user_id") `);
        await queryRunner.query(`CREATE INDEX "idx_badges_category" ON "badges" ("category") `);
        await queryRunner.query(`CREATE INDEX "idx_message_reactions_message_id" ON "message_reactions" ("message_id") `);
        await queryRunner.query(`CREATE INDEX "idx_group_messages_reply_to_id" ON "group_messages" ("reply_to_id") `);
        await queryRunner.query(`ALTER TABLE "user_badges" ADD CONSTRAINT "user_badges_badge_id_fkey" FOREIGN KEY ("badge_id") REFERENCES "badges"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "user_badges" ADD CONSTRAINT "user_badges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ADD CONSTRAINT "message_reactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "message_reactions" ADD CONSTRAINT "message_reactions_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "group_messages"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "group_messages" ADD CONSTRAINT "group_messages_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "group_messages"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
    }

}
