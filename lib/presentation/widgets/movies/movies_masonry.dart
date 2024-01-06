import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets.dart';

class MoviesMasonry extends StatefulWidget {
  final List<Movie> movie;
  const MoviesMasonry({super.key, required this.movie, this.loadNextPage});
  final VoidCallback? loadNextPage;
  @override
  State<MoviesMasonry> createState() => _MoviesMasonryState();
}

class _MoviesMasonryState extends State<MoviesMasonry> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if (scrollController.position.pixels + 100 == scrollController.position.maxScrollExtent) {
          widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,

        itemCount: widget.movie.length,
        mainAxisSpacing: 10, // space vertical
        crossAxisSpacing: 10, // space horizontal
        crossAxisCount: 3, // 3 columnas
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 30),
                MoviePosterLink(movie: widget.movie[index])
              ],
            );
          }
          return MoviePosterLink(movie: widget.movie[index]);
        },
      ),
    );
  }
}
