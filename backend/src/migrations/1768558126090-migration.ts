import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1768558126090 implements MigrationInterface {
    name = 'Migration1768558126090'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "users" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "email" character varying(255) NOT NULL, "password" character varying(255) NOT NULL, "name" character varying(255), "avatar_url" text, "daily_calorie_goal" integer NOT NULL DEFAULT '2500', "daily_protein_goal" integer NOT NULL DEFAULT '150', "daily_carbs_goal" integer NOT NULL DEFAULT '275', "daily_fat_goal" integer NOT NULL DEFAULT '70', "current_weight" numeric(5,2), "goal_weight" numeric(5,2), "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"), CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "food_entries" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "user_id" uuid NOT NULL, "name" character varying(255) NOT NULL, "calories" numeric(10,2) NOT NULL, "protein" numeric(10,2) NOT NULL, "carbs" numeric(10,2) NOT NULL, "fat" numeric(10,2) NOT NULL, "image_url" text, "ingredients" jsonb, "servings" numeric(5,2) NOT NULL DEFAULT '1', "logged_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), CONSTRAINT "PK_9ff4018d66bc4142ac2222a3ad0" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_15c73ca44d32c87f529bc60b79" ON "food_entries" ("user_id") `);
        await queryRunner.query(`CREATE INDEX "IDX_ffc81c6168cb32fd588624e060" ON "food_entries" ("logged_at") `);
        await queryRunner.query(`CREATE INDEX "IDX_adf1afbb04516894d216422d7b" ON "food_entries" ("user_id", "logged_at") `);
        await queryRunner.query(`CREATE TABLE "weight_logs" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "user_id" uuid NOT NULL, "weight" numeric(5,2) NOT NULL, "note" text, "logged_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), CONSTRAINT "PK_96c8f4d341846b34fef50cf4576" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_0341010b3956b50d880f4fe15b" ON "weight_logs" ("user_id") `);
        await queryRunner.query(`CREATE INDEX "IDX_3c02a9357a40a47cb9080fb45c" ON "weight_logs" ("logged_at") `);
        await queryRunner.query(`CREATE INDEX "IDX_51a634dd5cd58a36758b65a13d" ON "weight_logs" ("user_id", "logged_at") `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX "public"."IDX_51a634dd5cd58a36758b65a13d"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_3c02a9357a40a47cb9080fb45c"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_0341010b3956b50d880f4fe15b"`);
        await queryRunner.query(`DROP TABLE "weight_logs"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_adf1afbb04516894d216422d7b"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_ffc81c6168cb32fd588624e060"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_15c73ca44d32c87f529bc60b79"`);
        await queryRunner.query(`DROP TABLE "food_entries"`);
        await queryRunner.query(`DROP TABLE "users"`);
    }

}
