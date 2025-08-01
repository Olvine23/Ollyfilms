import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_app/features/movies/application/extensions/extensions.dart';
import 'package:movie_app/features/movies/presentation/movie_details.dart';
import 'package:movie_app/features/shared/screens/see_all.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCarousel extends StatelessWidget {
  final String title;
  final String seeAll;
  final List<MovieEntity> movies;
  final void Function(MovieEntity) onTap;

  /// Optional for infinite scrolling
  final VoidCallback? onLoadMore;

  const MovieCarousel({
    super.key,
    required this.title,
    required this.movies,
    required this.onTap,
    required this.seeAll,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeeAllScreen(
                        onLoadMore: onLoadMore,
                        title: seeAll,
                        movies: movies, // pass your actual movie list
                        onTap: (movie) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDetailsScreen(
                              movieId: movie.id,
                              movie: movie,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
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
                      child: CachedNetworkImage(
                        imageUrl: movie.fullPosterUrl,
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 120,
                          height: 160,
                          color: Colors.greenAccent,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 120,
                      child: Text(
                        truncateString(movie.title, 12),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
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
