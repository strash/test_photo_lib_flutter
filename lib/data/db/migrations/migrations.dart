import "package:sqflite/sqflite.dart";

export "./create_photos_table_migration_2.dart";
export "dummy_migration_1.dart";

abstract base class BaseMigration {
  /// Migrate UP
  Future<void> up(Database db);

  /// Migrate DOWN
  Future<void> down(Database db);
}
