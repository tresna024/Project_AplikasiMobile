import 'package:flutter/material.dart';
import 'package:project_flutter/movie/models/movie_cast_model.dart';
import 'package:project_flutter/movie/repostories/movie_repository.dart';

class MovieGetCastProvider extends ChangeNotifier {
  final MovieRepository repo;

  MovieGetCastProvider(this.repo);

  List<MovieCastModel>? casts;
  bool isLoading = false;
  String? error;

  Future<void> getCast(BuildContext context, {required int id}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await repo.getCast(id: id);

    result.fold(
      (e) {
        error = e;
        casts = [];
      },
      (data) {
        casts = data;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
