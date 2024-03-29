import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
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

  // Convierte la respuesta JSON de MovieDB en una lista de objetos Movie.
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    // Convierte el JSON en un objeto MovieDbResponse.
    final movieResponse = MovieDbResponse.fromJson(json);

    // Filtra las películas que no tienen una ruta de póster válida y las mapea a objetos Movie.
    final List<Movie> moviesList = movieResponse.results
        .where((moviedb) => moviedb.posterPath != '')
        .map((moviedb) => MovieMapper.movieDbToEntity(moviedb))
        .toList();

    // Devuelve la lista resultante.
    return moviesList;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) throw Exception("Movie with id: $id not found");
    final movieDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetaildToEntity(movieDetails);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async{
    
    if(query.isEmpty) return [];
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});

    return _jsonToMovies(response.data);
    
  }
}
