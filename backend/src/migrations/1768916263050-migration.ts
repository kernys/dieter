import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1768916263050 implements MigrationInterface {
    name = 'Migration1768916263050'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" ADD "height_feet" numeric(3,1)`);
        await queryRunner.query(`ALTER TABLE "users" ADD "height_inches" numeric(4,2)`);
        await queryRunner.query(`ALTER TABLE "users" ADD "height_cm" numeric(5,2)`);
        await queryRunner.query(`ALTER TABLE "users" ADD "birth_date" date`);
        await queryRunner.query(`ALTER TABLE "users" ADD "gender" character varying(20)`);
        await queryRunner.query(`ALTER TABLE "users" ADD "daily_step_goal" integer NOT NULL DEFAULT '10000'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "onboarding_completed" boolean`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "onboarding_completed"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "daily_step_goal"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "gender"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "birth_date"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "height_cm"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "height_inches"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "height_feet"`);
    }

}
