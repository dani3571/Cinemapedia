import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Este provider sera una lista de tipo movie y retornara 6 elementos del listado nowPLayingMovies
final sliceShowProvider =Provider<List<Movie>>((ref) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);

    if(nowPlayingMovies.isEmpty) return [];
    return nowPlayingMovies.sublist(0,6);
});