import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repositories.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





 final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int,Movie> >((ref) {
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
 } );


/*
  {
    123: Movie,
    243: Movie,
    654: Movie
  }
 */

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>>{
  int page = 0;
  final LocalStorageRepository localStorageRepository;
  StorageMoviesNotifier({required this.localStorageRepository}): super({});

  Future<List<Movie>> loadNextPage() async{
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
     page++;
    final tempMoviesMap = <int,Movie>{};

    //Convertimos la lista a map
    for(final movie in movies){
      tempMoviesMap[movie.id] = movie;
    }


    state = {...state, ...tempMoviesMap };
      return movies;
 }

  Future<void> toggleFavorite(Movie movie) async{

    await localStorageRepository.toggleFavorite(movie);
    final bool isMovieInFavorites = state[movie.id] !=null; 

    if(isMovieInFavorites){ // si la pelicula existe
      state.remove(movie.id);
      state = {...state};
    }else{
      state = {...state, movie.id:movie};
    }

  }
}
