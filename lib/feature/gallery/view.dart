import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:test_photo_lib/feature/gallery/bloc.dart";

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          switch (state.status) {
            case EGalleryStatus.data:
              final scale = MediaQuery.devicePixelRatioOf(context);
              final orientation = MediaQuery.orientationOf(context);
              final isPortrait = orientation == Orientation.portrait;
              final count = isPortrait ? 3 : 6;
              final viewSize = MediaQuery.sizeOf(context);
              final width = (viewSize.width - 5.0 * (count - 1)) / count;

              return CustomScrollView(
                slivers: [
                  // -> appbar
                  SliverAppBar(
                    title: Text("${state.isOffline ? "Offline" : ""} Gallery"),
                    pinned: isPortrait,
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.read<GalleryBloc>().add(
                            GalleryDataFetchRequested(),
                          );
                        },
                        icon: const Icon(Icons.update_rounded),
                      ),
                    ],
                  ),

                  // -> grid
                  SliverGrid.count(
                    crossAxisCount: count,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    children: state.photos
                        .map((e) {
                          if (e.data != null) {
                            return AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.memory(
                                e.data!,
                                fit: BoxFit.cover,
                                // оптимизируем редреринг изображений
                                cacheWidth: (width * scale).toInt(),
                              ),
                            );
                          }
                          return Text(e.title ?? "--");
                        })
                        .toList(growable: false),
                  ),

                  // -> bottom offset
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.viewPaddingOf(context).bottom + 50.0,
                    ),
                  ),
                ],
              );

            case EGalleryStatus.loading:
              return const Center(
                child: SizedBox.square(
                  dimension: 30.0,
                  child: CircularProgressIndicator.adaptive(),
                ),
              );

            case EGalleryStatus.error:
              return Center(child: Text(state.error?.toString() ?? "Error"));
          }
        },
      ),
    );
  }
}
