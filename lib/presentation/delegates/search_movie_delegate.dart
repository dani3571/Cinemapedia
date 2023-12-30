import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  List<Movie> initialMovies;
  // Usamos el StreamController.broadcast() para que varios widgets puedan escucharlo
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies, required this.initialMovies})
      : super(searchFieldLabel: "Buscar pelicula");

  // En caso de que deje de escribir por 5000 mls recien se hara la busqueda
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    // En caso de que esta activo que lo cancele
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);

      isLoadingStream.hasListener;

      // Asingnamos a initialMovies la lista de peliculas buscadas con el query
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  // funcion para cerrar el stream
  void _clearStreams() {
    debouncedMovies.close();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                  onPressed: () {
                    query = '';
                  },
                  icon: const Icon(Icons.refresh_rounded)),
            );
          }
          //  if (query.toString().isNotEmpty)

          return FadeIn(
            child: IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.close_outlined)),
          );
        },
      )
    ];
    /* return [
      if (query.toString().isNotEmpty)
        SpinPerfect(
          duration: const Duration(seconds: 20),
          spins: 10,
          infinite: true,
          child: IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.refresh_rounded)),
        ),
         /*FadeIn(
          child: IconButton(
              onPressed: () {
                query = '';
              },
              icon: const Icon(Icons.close_outlined)),
        )*/
    ];*/
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
          _clearStreams();
        },
        icon: const Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      // Asignamos el initialMovies en initialData para que no se hagan dos peticiones
      // en buildResults y buildSuggestions
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movie = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movie.length,
          itemBuilder: (context, index) => _MovieSeachItem(
              movie: movie[index],
              onMovieSelected: (context, movie) {
                _clearStreams();
                close(context, movie);
              }),
        );
      },
    );
  }
}
/*
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchMovies,
      builder: (context, snapshot) {
      // TODO  print("Realizando peticion");
        final movie = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movie.length,
          itemBuilder: (context, index) => _MovieSeachItem(movie: movie[index], onMovieSelected: close),
        );
      },
    );
  }
}
 */

class _MovieSeachItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieSeachItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            SizedBox(
                width: size.width * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    movie.posterPath,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2));
                      }
                      return FadeIn(child: child);
                    },
                  ),
                )),
            const SizedBox(width: 10),
            SizedBox(
                width: size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyle.titleMedium,
                    ),
                    movie.overview.length > 100
                        ? Text('${movie.overview.substring(0, 100)}...')
                        : Text(
                            movie.overview.substring(0, movie.overview.length)),
                    Row(
                      children: [
                        Icon(Icons.star_half_rounded,
                            color: Colors.yellow.shade800),
                        const SizedBox(width: 5),
                        Text(HumanFormats.number(movie.voteAverage, 1),
                            style: textStyle.bodyMedium
                                ?.copyWith(color: Colors.yellow.shade800))
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
