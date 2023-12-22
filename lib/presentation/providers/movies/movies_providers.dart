import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

final polularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

final upCommingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpComing;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies,
  );
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    // ! Funcionalidad de hacer la peticion una sola vez para optmizar los recursos
    // si es true bloqueamos para que no se haga la peticion nuevamente
    if (isLoading) return;

    // si esta en false se hace una peticion
    isLoading = true;
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];

    // ! Damos un tiempo para que las peliculas sean renderizadas
    await Future.delayed(const Duration(milliseconds: 300));
    // Cuando termine de de cargar la nueva pagina volvemos a su estado false
    isLoading = false;
  }
}
