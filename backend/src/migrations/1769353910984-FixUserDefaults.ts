import { MigrationInterface, QueryRunner } from "typeorm";

export class FixUserDefaults1769353910984 implements MigrationInterface {
    name = 'FixUserDefaults1769353910984'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "groups" DROP CONSTRAINT "groups_created_by_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "group_members" DROP CONSTRAINT "group_members_group_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "group_members" DROP CONSTRAINT "group_members_user_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "group_messages" DROP CONSTRAINT "group_messages_group_id_fkey"`);
        await queryRunner.query(`ALTER TABLE "group_messages" DROP CONSTRAINT "group_messages_user_id_fkey"`);
        await queryRunner.query(`DROP INDEX "public"."idx_group_members_group_id"`);
        await queryRunner.query(`DROP INDEX "public"."idx_group_members_user_id"`);
        await queryRunner.query(`DROP INDEX "public"."idx_group_messages_group_id"`);
        await queryRunner.query(`ALTER TABLE "group_members" DROP CONSTRAINT "group_members_group_id_user_id_key"`);
        await queryRunner.query(`ALTER TABLE "groups" ALTER COLUMN "is_private" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "group_members" ALTER COLUMN "score" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "group_members" ALTER COLUMN "role" SET NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "group_members" ALTER COLUMN "role" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "group_members" ALTER COLUMN "score" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "groups" ALTER COLUMN "is_private" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "group_members" ADD CONSTRAINT "group_members_group_id_user_id_key" UNIQUE ("group_id", "user_id")`);
        await queryRunner.query(`CREATE INDEX "idx_group_messages_group_id" ON "group_messages" ("group_id") `);
        await queryRunner.query(`CREATE INDEX "idx_group_members_user_id" ON "group_members" ("user_id") `);
        await queryRunner.query(`CREATE INDEX "idx_group_members_group_id" ON "group_members" ("group_id") `);
        await queryRunner.query(`ALTER TABLE "group_messages" ADD CONSTRAINT "group_messages_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "group_messages" ADD CONSTRAINT "group_messages_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "groups"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "group_members" ADD CONSTRAINT "group_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "group_members" ADD CONSTRAINT "group_members_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "groups"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "groups" ADD CONSTRAINT "groups_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
    }

}
