// Implementacion del repositorio


import 'package:cinemapedia/domain/datasources/movies_datasources.dart';
import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/domain/repositories/movies_repositories.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDataSource dataSource;

  MovieRepositoryImpl(this.dataSource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
      return dataSource.getNowPlaying(page: page);

  }
  
  @override
  Future<List<Movie>> getPopular({int page = 1}) {  
    return dataSource.getPopular(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return dataSource.getTopRated(page: page);  
  
  }
  
  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return dataSource.getUpComing(page: page);
  }
  
  @override
  Future<Movie> getMovieById(String id) {
   return dataSource.getMovieById(id);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
      return dataSource.searchMovies(query);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) {
    return dataSource.getSimilarMovies(movieId);
  }
  
  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) {
    return dataSource.getYoutubeVideosById(movieId);
  }
  
}