import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListiew extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;

  final VoidCallback? loadNextPage;
  const MovieHorizontalListiew(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListiew> createState() => _MovieHorizontalListiewState();
}

class _MovieHorizontalListiewState extends State<MovieHorizontalListiew> {
  final scrollController = ScrollController();

  // ! Si añadimos un listener debe tener un dispose para que sea limpiado
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      // * Si la posicion del scroll pasa del maximo empieza a cargar mas peliculas
      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        print("Mas cosas");
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
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          if (widget.title != null || widget.subTitle != null)
            _Title(
                title: widget.title.toString(),
                subTitle: widget.subTitle.toString()),
          Expanded(
              child: ListView.builder(
            itemCount: widget.movies.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemBuilder: (context, index) =>
                _Slide(movies: widget.movies[index]),
          )),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movies;
  const _Slide({required this.movies});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Image
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movies.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  // fade in animate
                  return FadeIn(child: child);
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          // * Title

          SizedBox(
            width: 150,
            child: Text(
              movies.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),
          const SizedBox(height: 2),

          // * Raiting
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.star_half_outlined,
                  color: Colors.yellow.shade800,
                ),
                const SizedBox(width: 3),
                Text('${movies.voteAverage}',
                    style: textStyle.bodyMedium
                        ?.copyWith(color: Colors.yellow.shade800)),
                const Spacer(),
                Text(HumanFormats.number(movies.popularity),
                    style: textStyle.bodySmall),
                //     Text(movies.popularity.toString())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});
  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          if (title != null)
            Text(
              title!,
              style: titleStyle,
            ),
          const Spacer(),
          if (subTitle != null)
            FilledButton.tonal(
              onPressed: () {},
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(
                subTitle!,
                style: titleStyle,
              ),
            )
        ],
      ),
    );
  }
}
