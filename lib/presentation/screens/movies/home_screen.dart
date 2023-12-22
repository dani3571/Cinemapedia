import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Scaffold(
        body: _HomeView(),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

// Implementando un ConsumerStateFulWidget
class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final moviesSlicesShow = ref.watch(sliceShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    if (moviesSlicesShow.isEmpty) const CircularProgressIndicator();
    // ! Usamos el CustomScrollView con slivers para poder usar el SliverAppBar con la funcionalidad de floating para que el appBar siga al scroll
    return CustomScrollView(slivers: [
      
      const SliverAppBar(
        floating: true,
        
        flexibleSpace: FlexibleSpaceBar(
          title: CustomAppBar(),
          centerTitle: false,
          titlePadding: EdgeInsets.zero,
        ),
      ),
 
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
      
            MoviesSlides(movies: moviesSlicesShow),
            MovieHorizontalListiew(
              movies: nowPlayingMovies,
              title: 'En cines',
              subTitle: 'Lunes 20',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListiew(
              movies: nowPlayingMovies,
              title: 'Proximamente',
              subTitle: 'En este mes',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListiew(
              movies: nowPlayingMovies,
              title: 'Populares',
              subTitle: null,
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListiew(
              movies: nowPlayingMovies,
              title: 'Mejor calificadas',
              subTitle: 'Desde siempre',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),
            const SizedBox(height: 10)
          ],
        );
      }, childCount: 1)),
    ]);
  }
}
