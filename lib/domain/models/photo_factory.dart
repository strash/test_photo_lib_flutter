import "package:test_photo_lib/data/db/dto/photo.dart";
import "package:test_photo_lib/data/external/dto/photo.dart";
import "package:test_photo_lib/domain/models/photo.dart";

// ignore: avoid_classes_with_only_static_members
final class PhotoFactory {
  static PhotoModel fromExternal(ExternalPhotoDto dto) {
    return PhotoModel(
      id: dto.id,
      url: dto.url,
      title: dto.title,
      description: dto.description,
      user: dto.user,
      data: dto.data,
    );
  }

  static PhotoModel fromDB(DBPhotoDto dto) {
    return PhotoModel(
      id: dto.id,
      url: dto.url,
      title: dto.title,
      description: dto.description,
      user: dto.user,
      data: dto.data,
    );
  }

  static DBPhotoDto externalToDB(ExternalPhotoDto dto) {
    return DBPhotoDto(
      id: dto.id,
      url: dto.url,
      title: dto.title,
      description: dto.description,
      user: dto.user,
      data: dto.data,
    );
  }
}
