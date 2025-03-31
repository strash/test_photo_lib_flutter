import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:test_photo_lib/data/external/dto/photo.dart";
import "package:test_photo_lib/domain/repository/external_photo.dart";

final class ExternalPhotoRepository implements IExternalPhotoRepository {
  @override
  Future<List<ExternalPhotoDto>> getAll() async {
    try {
      // скачиваем список изображений
      final uri = Uri.https("api.slingacademy.com", "/v1/sample-data/photos", {
        "limit": "24",
        "offset": "0",
      });
      final headers = {"content-type": "application/json"};
      final res = await http.get(uri, headers: headers);
      if (res.statusCode != 200) return const [];

      // парсим json в список dto
      final data = json.decode(res.body) as Map<String, dynamic>?;
      final dtos = ((data?["photos"] as List<dynamic>?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(ExternalPhotoDto.fromMap)
          .toList(growable: false);

      // скачиваем изображения
      final photosRes = await Future.wait<http.Response?>(
        dtos.map((e) {
          final uri = Uri.tryParse(e.url ?? "");
          if (uri == null) return Future.value();
          return http.get(uri);
        }),
      );

      // обновляем dto и возвращаем их
      return dtos.indexed
          .map((e) {
            final res = photosRes.elementAt(e.$1);
            if (res?.statusCode == 200) {
              return e.$2.copyWith(data: res?.bodyBytes);
            }
            return e.$2;
          })
          .toList(growable: false);
    } on http.ClientException catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
