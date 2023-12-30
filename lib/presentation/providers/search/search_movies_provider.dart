import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchMoviesProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SeachedMoviesNotifier, List<Movie>>((ref) {
    final seachMovies = ref.read(movieRepositoryProvider);
    return SeachedMoviesNotifier(ref: ref, searchMovies: seachMovies.searchMovies);

});


typedef SearchMoviesCallBack = Future<List<Movie>> Function (String query);
class SeachedMoviesNotifier extends StateNotifier<List<Movie>>{
    SearchMoviesCallBack searchMovies;
    final Ref ref;
    SeachedMoviesNotifier({required this.ref, required this.searchMovies}): super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async{
      final List<Movie> movies = await searchMovies(query);
      state = movies;
      ref.read(searchMoviesProvider.notifier).state = query;
    
      return movies;
  }
}