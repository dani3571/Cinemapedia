import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

// Implementando un ConsumerStateFulWidget
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upCommingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final moviesSlicesShow = ref.watch(sliceShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    // final popularMovies = ref.watch(polularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upComingMovies = ref.watch(upCommingMoviesProvider);

    // ! Usamos el CustomScrollView con slivers para poder usar el SliverAppBar con la funcionalidad de floating para que el appBar siga al scroll
    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: false,
        title: CustomAppBar(),

        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            MoviesSlideshow(movies: moviesSlicesShow),
            MovieHorizontalListview(
              movies: nowPlayingMovies,
              title: 'En cines',
              subTitle: 'Lunes 20',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
            ),

            MovieHorizontalListview(
              movies: upComingMovies,
              title: 'Proximamente',
              subTitle: 'En este mes',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(upCommingMoviesProvider.notifier).loadNextPage(),
            ),

            //* Ya no estará aquí, ahora es parte del menú inferior
            // MovieHorizontalListview(
            //   movies: popularMovies,
            //   title: 'Populares',
            //   loadNextPage: () =>ref.read(popularMoviesProvider.notifier).loadNextPage()
            // ),

            MovieHorizontalListview(
              movies: topRatedMovies,
              title: 'Mejor calificadas',
              subTitle: 'Desde siempre',
              // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
              loadNextPage: () =>
                  ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
            ),
            const SizedBox(height: 10)
          ],
        );
      }, childCount: 1)),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
