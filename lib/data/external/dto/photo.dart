import "dart:typed_data";

final class ExternalPhotoDto {
  final int id;
  final String? url;
  final String? title;
  final String? description;
  final int? user;
  final Uint8List? data;

  const ExternalPhotoDto({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.user,
    this.data,
  });

  factory ExternalPhotoDto.fromMap(Map<String, dynamic> map) {
    return ExternalPhotoDto(
      id: map["id"] as int,
      url: map["url"] as String?,
      title: map["title"] as String?,
      description: map["description"] as String?,
      user: map["user"] as int?,
    );
  }

  ExternalPhotoDto copyWith({
    String? url,
    String? title,
    String? description,
    int? user,
    Uint8List? data,
  }) {
    return ExternalPhotoDto(
      id: id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      user: user ?? this.user,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExternalPhotoDto &&
            (id == other.id &&
                url == other.url &&
                title == other.title &&
                description == other.description &&
                user == other.user &&
                data == other.data);
  }

  @override
  int get hashCode {
    return Object.hash(id, url, title, description, user, data);
  }
}
