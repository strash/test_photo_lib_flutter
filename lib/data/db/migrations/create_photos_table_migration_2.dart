import "package:sqflite/sqflite.dart";
import "package:test_photo_lib/data/db/migrations/migrations.dart";

final class CreatePhotosTableMigration2 extends BaseMigration {
  String get _table => "photos";

  @override
  Future<void> up(Database db) async {
    await db.rawQuery("""
CREATE TABLE IF NOT EXISTS $_table (
id          INTEGER PRIMARY KEY NOT NULL,
url         TEXT    DEFAULT ''  NOT NULL,
title       TEXT,
description TEXT,
user        INTEGER,
data        BLOB
);
""");
  }

  @override
  Future<void> down(Database db) async {
    await db.rawQuery("DROP TABLE IF EXISTS $_table;");
    await db.rawQuery("VACUUM;");
  }
}
