import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
        (ref) {
  final actorRepository = ref.watch(actorRepositoryProvider);
  return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovieId);
});

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

// Mapa donde se tendra la id y apuntara a una instancia de movie
// Clase para guardar en el cache las peticiones
class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    // Si ya se tiene el valor de movieDB que retorne
    if (state[movieId] != null) return;

    // si no lo tiene que haga la peticion y cambie el estado
    final List<Actor> actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}
