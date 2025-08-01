import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/movie_provider.dart';
import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_carousel.dart';
import 'package:movie_app/features/movies/presentation/widgets/movier_caroussel_loader.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final void Function(MovieEntity movie) onMovieTap;

  const ExploreScreen({super.key, required this.onMovieTap});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  Genre? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    final genresAsync = ref.watch(genreProvider);
    final genreMoviesAsync = _selectedGenre != null
        ? ref.watch(moviesByGenreProvider(_selectedGenre!.id))
        : null;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(genreProvider);
        ref.invalidate(nowPlayingProvider);
        ref.invalidate(topRatedProvider);
        if (_selectedGenre != null) {
          ref.invalidate(moviesByGenreProvider(_selectedGenre!.id));
        }
      },
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: const Text(
                "Explore by Genre",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: genresAsync.when(
                data: (genres) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genres.map((g) {
                    final isSelected = _selectedGenre?.id == g.id;
                    return ChoiceChip(
                      label: Text(g.name),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedGenre = g);
                      },
                    );
                  }).toList(),
                ),
                loading: () => const Center(child: MovieCarouselShimmer()),
                error: (e, _) => Text("Failed to load genres"),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedGenre != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Results for: ${_selectedGenre!.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              genreMoviesAsync!.when(
                data: (movies) => Column(
                  children: [
                    
                    MovieCarousel(
                      title: "Genre: ${_selectedGenre!.name}",
                      movies: movies,
                      onTap: widget.onMovieTap, seeAll: _selectedGenre!.name,
                    ),
                  ],
                ),
                loading: () => const Center(child: MovieCarouselShimmer()),
                error: (e, _) => Text("Error loading genre movies"),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
