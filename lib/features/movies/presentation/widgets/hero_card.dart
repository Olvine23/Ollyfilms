import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

class HeroCarousel extends StatefulWidget {
  final List<MovieEntity> movies;
  final void Function(MovieEntity) onTap;

  const HeroCarousel({super.key, required this.movies, required this.onTap});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1);

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (next != currentIndex) {
        setState(() => currentIndex = next);
      }
    });
  }

 @override
Widget build(BuildContext context) {
  final movie = widget.movies[currentIndex];
  final topPadding = MediaQuery.of(context).padding.top;

  return SizedBox(
    height: 420,
    child: Stack(
      children: [
        // 🎥 Background image fills entire space (no padding)
        PageView.builder(
          controller: _pageController,
          itemCount: widget.movies.length,
          itemBuilder: (ctx, i) {
            final m = widget.movies[i];
            return GestureDetector(
              onTap: () => widget.onTap(m),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w780${m.posterUrl}',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // 🎬 Title & Button with top safe area padding
        Positioned(
          bottom: 40,
          left: 16,
          right: 16,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => widget.onTap(movie),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Watch Trailer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


}
