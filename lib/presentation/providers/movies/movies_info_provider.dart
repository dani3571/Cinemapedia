import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch( movieRepositoryProvider );
  return MovieMapNotifier(getMovie: movieRepository.getMovieById );
});


/*
  {
    '505642': Movie(),
    '505643': Movie(),
    '505645': Movie(),
    '501231': Movie(),
  }
*/


typedef GetMovieCallback = Future<Movie>Function(String movieId);
// Mapa donde se tendra la id y apuntara a una instancia de movie
// Clase para guardar en el cache las peticiones
class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{
    final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}):super({});
   
    
    Future<void> loadMovie(String movieId) async{
     
      // Si ya se tiene el valor de movieDB que retorne 
      if(state[movieId] != null) return;
      // si no lo tiene que haga la peticion y cambie el estado
      final movie = await getMovie(movieId);
      state = {...state, movieId:movie}; 

    }
}