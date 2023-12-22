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
    final moviesProvider = ref.watch(nowPlayingMoviesProvider);
    if (moviesSlicesShow.isEmpty) const CircularProgressIndicator();

    return Column(
      children: [
        const CustomAppBar(),
        MoviesSlides(movies: moviesSlicesShow),
        MovieHorizontalListiew(
          movies: moviesProvider,
          title: 'En cines',
          subTitle: 'Lunes 20',
          // ! Usamos el .read cuando estamos dentor de funciones o callbacks como este caso
          loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage() ,
        ),


      ],
    );
  }
}
