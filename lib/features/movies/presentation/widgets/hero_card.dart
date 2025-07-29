import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

class HeroCarousel extends StatefulWidget {
  final List<MovieEntity> movies;
  final void Function(MovieEntity) onTap;

  const HeroCarousel({super.key, required this.movies, required this.onTap});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _zoomController;
  late final Animation<double> _zoomAnimation;

  int currentIndex = 1;
  Timer? _autoSlideTimer;

  List<MovieEntity> get _loopedMovies {
    if (widget.movies.length < 2) return widget.movies;
    return [
      widget.movies.last,
      ...widget.movies,
      widget.movies.first,
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex, viewportFraction: 1);

    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handlePageChanged(int index) {
    setState(() => currentIndex = index);

    if (index == 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _pageController.jumpToPage(_loopedMovies.length - 2);
      });
    } else if (index == _loopedMovies.length - 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _pageController.jumpToPage(1);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _zoomController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final visibleIndex = currentIndex % widget.movies.length;

    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _loopedMovies.length,
            onPageChanged: _handlePageChanged,
            itemBuilder: (ctx, i) {
              final movie = _loopedMovies[i];
              final isCurrent = i == currentIndex;

              final image = Image.network(
                'https://image.tmdb.org/t/p/w780${movie.posterUrl}',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 160, color: Colors.grey),
              );

              final imageWidget = isCurrent
                  ? AnimatedBuilder(
                      animation: _zoomAnimation,
                      builder: (_, child) => Transform.scale(
                        scale: _zoomAnimation.value,
                        child: child,
                      ),
                      child: image,
                    )
                  : image;

              return GestureDetector(
                onTap: () => widget.onTap(movie),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageWidget,
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black87, Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Title + Play Button
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
                    _loopedMovies[currentIndex].title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    
                    onPressed: () => widget.onTap(_loopedMovies[currentIndex]),
                    icon: const Icon(Icons.play_arrow),
                    label: Text("Watch Trailer", style: TextStyle(fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.movies.length, (index) {
                      final isActive = visibleIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 12 : 8,
                        height: isActive ? 12 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.greenAccent : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
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
