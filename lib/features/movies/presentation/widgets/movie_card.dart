import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/application/extensions/extensions.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieCard extends StatelessWidget {
  final MovieEntity movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: movie.fullPosterUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          truncateString(movie.title, 14),
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
