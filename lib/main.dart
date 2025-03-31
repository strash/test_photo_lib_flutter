import "package:flutter/material.dart";
import "package:test_photo_lib/data/db/db.dart";
import "package:test_photo_lib/feature/gallery/page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance().db;

  runApp(const MaterialApp(home: GalleryPage()));
}
