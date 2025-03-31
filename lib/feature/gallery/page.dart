import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_photo_lib/data/db/repository/photo.dart";
import "package:test_photo_lib/data/external/repository/photo.dart";
import "package:test_photo_lib/feature/gallery/bloc.dart";
import "package:test_photo_lib/feature/gallery/view.dart";

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GalleryBloc>(
      lazy: false,
      create: (context) {
        final bloc = GalleryBloc(
          dbRepo: DBPhotoRepository(),
          externalRepo: ExternalPhotoRepository(),
        );
        bloc.add(GalleryDataFetchRequested());
        return bloc;
      },
      child: const GalleryView(),
    );
  }
}
