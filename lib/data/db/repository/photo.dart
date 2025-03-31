import "package:flutter/foundation.dart";
import "package:sqflite/sqflite.dart";
import "package:test_photo_lib/data/db/db.dart";
import "package:test_photo_lib/data/db/dto/photo.dart";
import "package:test_photo_lib/domain/repository/db_photo.dart";

final class DBPhotoRepository implements IDBPhotoRepository {
  String get _table => "photos";

  @override
  Future<List<DBPhotoDto>> getAll() async {
    try {
      final db = await AppDatabase.instance().db;
      final maps = await db.query(_table);

      return maps.map(DBPhotoDto.fromMap).toList(growable: false);
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  @override
  Future<void> upsert(DBPhotoDto dto) async {
    try {
      final db = await AppDatabase.instance().db;
      await db.insert(
        _table,
        dto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
