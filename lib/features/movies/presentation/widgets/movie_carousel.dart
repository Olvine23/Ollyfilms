 
import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/application/extensions/extensions.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCarousel extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;
  final void Function(MovieEntity) onTap;

  const MovieCarousel({
    super.key,
    required this.title,
    required this.movies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18)),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: movies.length,
            itemBuilder: (_, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => onTap(movie),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterUrl}',
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(truncateString(movie.title, 12))
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}
