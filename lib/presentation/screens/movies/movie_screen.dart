import 'package:cinemapedia/presentation/providers/movies/movies_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/movie.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;
  static const name = 'movie-screen';
  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    // Este es el mapa                           quiero que busque esto del mapa
    final movie = ref.watch(movieDetailsProvider)[widget.movieId];
    if (movie == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_CustomSliverAppBar(movie: movie)],
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    //Tomamos el tamaño de espacio del dispositivo
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7, // 70% de la pantalla
      foregroundColor: Colors.white,
      shadowColor: Colors.red,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        background: Stack(children: [
          SizedBox.expand(
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
            ),
          ),
          // ! GRADIENTE
          const Gradient(
              alignmentBegin: Alignment.topCenter,
              alignmentEnd: Alignment.bottomCenter,
              stops: [0.7, 1.0],
              colors: [Colors.transparent, Colors.black]),
          const Gradient(
              alignmentBegin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent]),
        ]),
      ),
    );
  }
}

class Gradient extends StatelessWidget {
  final AlignmentGeometry alignmentBegin;
  final AlignmentGeometry? alignmentEnd;
  final List<double> stops;
  final List<Color> colors;
  const Gradient({
    Key? key,
    required this.alignmentBegin,
    this.alignmentEnd,
    required this.stops,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: alignmentBegin,
                  end: alignmentEnd ?? Alignment.centerRight,
                  stops: stops,
                  colors: colors))),
    );
  }
}


/*
  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7,1.0],
              colors: [Colors.transparent,Colors.black87]

            )
          )
    ),
    );
  }
 */