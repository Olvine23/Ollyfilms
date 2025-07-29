import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/core/theme_provider.dart';
import 'package:movie_app/features/movies/application/providers/movie_provider.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
import 'package:movie_app/features/movies/presentation/movie_details.dart';
import 'package:movie_app/features/movies/presentation/screens/gemini_recommeder.dart';
import 'package:movie_app/features/movies/presentation/screens/search/search_screen.dart';
import 'package:movie_app/features/movies/presentation/widgets/hero_card.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_carousel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popular = ref.watch(movieListProvider);
    final topRated = ref.watch(topRatedProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    Future<void> _refresh() async {
      // Force a refresh by invalidating the provider
      ref.invalidate(movieListProvider);
      ref.invalidate(topRatedProvider);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.tips_and_updates, size: 30, color: Colors.indigo),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeminiRecommendationsScreen(),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  visualDensity: VisualDensity(horizontal: 2),
                  
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.wb_sunny
                        : Icons.nightlight_round, size: 30,
                  ),
                  onPressed: () {
                    final isDark = themeMode != ThemeMode.dark;
                    ref.read(themeProvider.notifier).toggleTheme(isDark);
                  },
                ),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieSearchScreen(),
                    ),
                  ),
                  child: Icon(Icons.search, size: 30, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
        title: const Text(
          '🎬 OllyFilms',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        
        onRefresh: () => _refresh(),
        child: popular.when(
          data: (popularMovies) {
            final topRatedMovies = topRated.valueOrNull;
            return CustomScrollView(
              slivers: [
                if (popularMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: HeroCarousel(
                      movies: popularMovies.take(5).toList(),
                      onTap: (movie) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TestDetailsScreen(movieId: movie.id, movie: movie),
                        ),
                      ),
                    ),
                  ),
                // const SizedBox(height: 16),
                SliverToBoxAdapter(
                  child: MovieCarousel(
                    title: 'Popular',
                    movies: popularMovies.skip(1).toList(),
                    onTap: (movie) async {
                      final key = await ref.read(mainTrailerKey(movie.id));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TestDetailsScreen(movieId: movie.id, movie: movie),
                        ),
                      );
                    },
                  ),
                ),
        
                SliverToBoxAdapter(child: SizedBox(height: 12)),
                // You can add more carousels here like Trending, Top Rated, etc.
                if (topRatedMovies != null && topRatedMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: MovieCarousel(
                      title: 'Top Rated',
                      movies: topRatedMovies,
                      onTap: (movie) async {
                        final key = await ref.read(mainTrailerKey(movie.id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestDetailsScreen(
                              movieId: movie.id,
                              movie: movie,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
