import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

// ! Este mapper convertira el MovieDB a la entidad Movie, esto se hace para que en caso se tenga que cambiar un nombre se haga directamente aqui.
class MovieMapper {
  static Movie movieDbToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '') 
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://img.freepik.com/free-vector/404-error-with-landscape-concept-illustration_114360-7898.jpg?size=626&ext=jpg&ga=GA1.1.1546980028.1702944000&semt=ais',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '') 
      ? 'https://image.tmdb.org/t/p/w500/${moviedb.posterPath}'
      : 'https://img.freepik.com/free-vector/404-error-with-landscape-concept-illustration_114360-7898.jpg?size=626&ext=jpg&ga=GA1.1.1546980028.1702944000&semt=ais',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);

    static Movie MovieDetaildToEntity(MovieDetails moviedb) => Movie(

    adult: moviedb.adult,
      backdropPath: (moviedb.backdropPath != '') 
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://img.freepik.com/free-vector/404-error-with-landscape-concept-illustration_114360-7898.jpg?size=626&ext=jpg&ga=GA1.1.1546980028.1702944000&semt=ais',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: (moviedb.posterPath != '') 
      ? 'https://image.tmdb.org/t/p/w500/${moviedb.posterPath}'
      : 'https://img.freepik.com/free-vector/404-error-with-landscape-concept-illustration_114360-7898.jpg?size=626&ext=jpg&ga=GA1.1.1546980028.1702944000&semt=ais',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount
    );
}

