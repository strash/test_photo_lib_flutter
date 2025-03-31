import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:http/http.dart" as http;
import "package:sqflite/sqlite_api.dart";
import "package:test_photo_lib/domain/models/photo.dart";
import "package:test_photo_lib/domain/models/photo_factory.dart";
import "package:test_photo_lib/domain/repository/db_photo.dart";
import "package:test_photo_lib/domain/repository/external_photo.dart";

part "./event.dart";
part "./state.dart";

final class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final IDBPhotoRepository _dbRepo;
  final IExternalPhotoRepository _externalRepo;

  GalleryBloc({
    required IDBPhotoRepository dbRepo,
    required IExternalPhotoRepository externalRepo,
  }) : _dbRepo = dbRepo,
       _externalRepo = externalRepo,
       super(GalleryState.initial()) {
    on<GalleryDataFetchRequested>(_onDataFetchRequested);
  }

  Future<void> _onDataFetchRequested(
    GalleryDataFetchRequested event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: EGalleryStatus.loading));
    try {
      // сначала пробуем выкачать данные из сети
      final data = await _externalRepo.getAll();
      emit(
        state.copyWith(
          status: EGalleryStatus.data,
          photos: data.map(PhotoFactory.fromExternal).toList(growable: false),
          isOffline: false,
        ),
      );
      // кешируем в фоне
      Future.wait(
        data.map((e) => _dbRepo.upsert(PhotoFactory.externalToDB(e))),
      ).catchError((e) {
        if (kDebugMode) print(e);
        return [];
      }, test: (e) => e is DatabaseException);
    } on http.ClientException catch (e) {
      if (kDebugMode) print(e.message);
      try {
        // если была ошибка при скачивании из сети, пробуем достать из кеша
        final cache = await _dbRepo.getAll();
        if (cache.isNotEmpty) {
          emit(
            state.copyWith(
              status: EGalleryStatus.data,
              photos: cache.map(PhotoFactory.fromDB).toList(growable: false),
              isOffline: true,
            ),
          );
        } else {
          // если в кеше пусто, отображаем ошибку
          emit(state.copyWith(status: EGalleryStatus.error, error: e));
        }
      } on DatabaseException catch (dbe) {
        if (kDebugMode) print(dbe);
        emit(state.copyWith(status: EGalleryStatus.error, error: dbe));
      }
    }
  }
}
