import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async{
    if(isLastPage || isLoading) return;

    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage(); 
    isLoading = false;

    if(movies.isEmpty) isLastPage = true;

  }

  @override
  Widget build(BuildContext context) {
    //Convertimos el mapa en una lista
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    return Scaffold(
        body: MoviesMasonry(movie: favoritesMovies, loadNextPage: loadNextPage));
  }
}
