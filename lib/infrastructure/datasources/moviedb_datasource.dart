import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/enviroment.dart';
import '../../domain/datasources/movies_datasources.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';


class MoviedbDatasource extends MoviesDataSource {
  // * implementamos los metodos que MoviesDataSource pida al MovieDBDatasource

  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDBKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    final movieDBResponseData = MovieDbResponse.fromJson(response.data);
    final List<Movie> moviesList = movieDBResponseData.results
        .where((movieDb) => movieDb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDbToEntity(moviedb))
        .toList();
    return moviesList;
  }
}
