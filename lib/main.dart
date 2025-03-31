import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_photo_lib/data/db/db.dart";
import "package:test_photo_lib/data/db/repository/photo.dart";
import "package:test_photo_lib/data/external/repository/photo.dart";
import "package:test_photo_lib/domain/repository/db_photo.dart";
import "package:test_photo_lib/domain/repository/external_photo.dart";
import "package:test_photo_lib/feature/gallery/page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // инициализируем sqlite. запускаются миграции
  await AppDatabase.instance.db;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IExternalPhotoRepository>(
          create: (context) => ExternalPhotoRepository(),
        ),
        RepositoryProvider<IDBPhotoRepository>(
          create: (context) => DBPhotoRepository(),
        ),
      ],
      child: const MaterialApp(home: GalleryPage()),
    ),
  );
}
