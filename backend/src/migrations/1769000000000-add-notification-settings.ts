import { MigrationInterface, QueryRunner } from "typeorm";

export class AddNotificationSettings1769000000000 implements MigrationInterface {
    name = 'AddNotificationSettings1769000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" ADD "breakfast_reminder_enabled" boolean NOT NULL DEFAULT true`);
        await queryRunner.query(`ALTER TABLE "users" ADD "breakfast_reminder_time" character varying(5) DEFAULT '08:30'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "lunch_reminder_enabled" boolean NOT NULL DEFAULT true`);
        await queryRunner.query(`ALTER TABLE "users" ADD "lunch_reminder_time" character varying(5) DEFAULT '11:30'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "snack_reminder_enabled" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "users" ADD "snack_reminder_time" character varying(5) DEFAULT '16:00'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "dinner_reminder_enabled" boolean NOT NULL DEFAULT true`);
        await queryRunner.query(`ALTER TABLE "users" ADD "dinner_reminder_time" character varying(5) DEFAULT '18:00'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "end_of_day_reminder_enabled" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "users" ADD "end_of_day_reminder_time" character varying(5) DEFAULT '21:00'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "end_of_day_reminder_time"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "end_of_day_reminder_enabled"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "dinner_reminder_time"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "dinner_reminder_enabled"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "snack_reminder_time"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "snack_reminder_enabled"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "lunch_reminder_time"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "lunch_reminder_enabled"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "breakfast_reminder_time"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "breakfast_reminder_enabled"`);
    }

}
