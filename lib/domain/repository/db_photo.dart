import "package:test_photo_lib/data/db/dto/photo.dart";

abstract interface class IDBPhotoRepository {
  Future<List<DBPhotoDto>> getAll();

  Future<void> upsert(DBPhotoDto dto);
}
