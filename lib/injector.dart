import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:project_flutter/movie/providers/movie_get_detail_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_discover_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_now_playing_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_top_rated_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_videos_provider.dart';
import 'package:project_flutter/movie/providers/movie_search_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_cast_provider.dart';
import 'package:project_flutter/movie/repostories/movie_repository.dart';
import 'package:project_flutter/movie/repostories/movie_repositor_impl.dart';
import 'package:project_flutter/movie/providers/bookmark_provider.dart';

import 'app_constants.dart';

final sl = GetIt.instance;

void setup() {
  // Register Provider
  sl.registerFactory<MovieGetDiscoverProvider>(
    () => MovieGetDiscoverProvider(sl()),
  );
  sl.registerFactory<MovieGetTopRatedProvider>(
    () => MovieGetTopRatedProvider(sl()),
  );
  sl.registerFactory<MovieGetNowPlayingProvider>(
    () => MovieGetNowPlayingProvider(sl()),
  );
  sl.registerFactory<MovieGetDetailProvider>(
    () => MovieGetDetailProvider(sl()),
  );
  sl.registerFactory<MovieGetVideosProvider>(
    () => MovieGetVideosProvider(sl()),
  );
  sl.registerFactory<MovieSearchProvider>(
    () => MovieSearchProvider(sl()),
  );
  sl.registerFactory<MovieGetCastProvider>(
    () => MovieGetCastProvider(sl()),
  );
  sl.registerFactory<BookmarkProvider>(
    () => BookmarkProvider()
  );

  // Register Repository
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));

  // Register Http Client (DIO)
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        queryParameters: {'api_key': AppConstants.apiKey},
      ),
    ),
  );
}
