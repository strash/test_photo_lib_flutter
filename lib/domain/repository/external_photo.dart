import "package:test_photo_lib/data/external/dto/photo.dart";

abstract interface class IExternalPhotoRepository {
  Future<List<ExternalPhotoDto>> getAll();
}
