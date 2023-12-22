import 'package:cinemapedia/domain/entities/movie.dart';

// Es abstracta porque no queremos instancias de la clase
abstract class MoviesDataSource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getUpComing({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
}
