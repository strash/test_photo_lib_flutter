import "package:sqflite/sqflite.dart";
import "package:test_photo_lib/data/db/migrations/migrations.dart";

// NOTE: нужно, чтобы миграции с 1 начинались
final class DummyMigration1 extends BaseMigration {
  @override
  Future<void> up(Database db) async {}

  @override
  Future<void> down(Database db) async {}
}
