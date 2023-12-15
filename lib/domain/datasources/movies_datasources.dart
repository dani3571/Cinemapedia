import 'package:cinemapedia/domain/entities/movie.dart';

// Es abstracta porque no queremos instancias de la clase
abstract class MovieDataSource{ 
  Future<List<Movie>> getNowPlaying({int page = 1});
}