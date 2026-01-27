import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1769492660435 implements MigrationInterface {
    name = 'Migration1769492660435'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "fiber" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "sugar" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "sodium" SET NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "sodium" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "sugar" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "food_entries" ALTER COLUMN "fiber" DROP NOT NULL`);
    }

}
