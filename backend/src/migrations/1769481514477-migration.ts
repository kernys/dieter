import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1769481514477 implements MigrationInterface {
    name = 'Migration1769481514477'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "exercise_entries" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "user_id" uuid NOT NULL, "type" character varying(255) NOT NULL, "duration" integer NOT NULL DEFAULT '0', "calories_burned" integer NOT NULL, "intensity" character varying(50), "description" text, "logged_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), CONSTRAINT "PK_6e40f5a4cb5be028457e25bed82" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_5af138186abe222c6bd9cb305b" ON "exercise_entries" ("user_id") `);
        await queryRunner.query(`CREATE INDEX "IDX_8c52a7b52aeafce4145fdea771" ON "exercise_entries" ("logged_at") `);
        await queryRunner.query(`CREATE INDEX "IDX_c074771787aca346fc71aac4a6" ON "exercise_entries" ("user_id", "logged_at") `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX "public"."IDX_c074771787aca346fc71aac4a6"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_8c52a7b52aeafce4145fdea771"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_5af138186abe222c6bd9cb305b"`);
        await queryRunner.query(`DROP TABLE "exercise_entries"`);
    }

}
