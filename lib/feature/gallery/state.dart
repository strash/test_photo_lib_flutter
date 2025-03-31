part of "./bloc.dart";

enum EGalleryStatus { data, loading, error }

final class GalleryState {
  final EGalleryStatus status;
  final List<PhotoModel> photos;
  final bool isOffline;
  final Exception? error;

  GalleryState({
    required this.status,
    required this.photos,
    required this.isOffline,
    this.error,
  });

  factory GalleryState.initial() => GalleryState(
    status: EGalleryStatus.data,
    isOffline: false,
    photos: const [],
  );

  GalleryState copyWith({
    EGalleryStatus? status,
    List<PhotoModel>? photos,
    bool? isOffline,
    Exception? error,
  }) {
    return GalleryState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      isOffline: isOffline ?? this.isOffline,
      error: error ?? this.error,
    );
  }
}
