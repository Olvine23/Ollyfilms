import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/movie_provider.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/screens/watchlist/youtube_vids.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_carousel.dart';
import 'package:movie_app/features/movies/presentation/widgets/movier_caroussel_loader.dart';
import 'package:movie_app/features/watchlist/presentation/widgets/watchlist_sheet.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TestDetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final MovieEntity movie;

  const TestDetailsScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  @override
  ConsumerState<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends ConsumerState<TestDetailsScreen> {
  YoutubePlayerController? _controller;
  bool showPlayer = false;
  bool isLoadingTrailer = false;
  String? error;

  

  Future<void> loadTrailer() async {
    setState(() {
      isLoadingTrailer = true;
      error = null;
    });

    try {
      final key = await ref.read(mainTrailerKey(widget.movieId).future);

      if (key != null) {
        _controller = YoutubePlayerController(
          initialVideoId: key,
          flags: const YoutubePlayerFlags(
            forceHD: true,
            autoPlay: true, mute: false),
        );
        setState(() {
          showPlayer = true;
        });
      } else {
        setState(() {
          error = "Trailer not available.";
        });
      }
    } catch (e) {
      setState(() {
        error = "Error loading trailer.";
      });
    } finally {
      setState(() {
        isLoadingTrailer = false;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // or dark
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = ref.watch(recommendedProvider(widget.movieId));

    final watchProviders = ref.watch(watchProvidersProvider(widget.movieId));

    final relatedVideos = ref.watch(youTubeVideosProvider(widget.movieId));

    print(relatedVideos);

    final similar = ref.watch(similarMoviesProvider(widget.movieId));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           showModalBottomSheet(
      context: context,
      builder: (_) => WatchlistSheet(movie: widget.movie),
    );
        },
        child: Icon(Icons.add),

      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: showPlayer
            ? null
            : Text(
                widget.movie.title,
                style: const TextStyle(color: Colors.white),
              ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 14 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (showPlayer && _controller != null)
                  SizedBox.expand(
                    child: YoutubePlayer(controller: _controller!),
                  )
                else
                  Image.network(
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,

                      size: 160,
                      color: Colors.grey,
                    ),
                    'https://image.tmdb.org/t/p/w780${widget.movie.posterUrl}',
                    fit: BoxFit.cover,
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ),
                if (!showPlayer && !isLoadingTrailer)
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_circle,
                        size: 64,
                        color: Colors.greenAccent,
                      ),
                      onPressed: loadTrailer,
                    ),
                  ),
                if (isLoadingTrailer)
                  const Center(child: CircularProgressIndicator()),
                if (error != null)
                  Center(
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.movie.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(width: 2,),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 35, 97, 67),
                      surfaceTintColor:Colors.lightGreenAccent ,
                      overlayColor: Colors.red,
                      shadowColor: Colors.greenAccent),
                    icon: Icon(Icons.video_collection, ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return YouTubeDetailsScreen(movieId: widget.movieId, movie: widget.movie);
                      }));
                    },
                    label: Text("More Videos"),
                  ),
                ),
              ],
            ),
          ),

          watchProviders.when(
  data: (providers) => Padding(
    padding: const EdgeInsets.symmetric(horizontal:14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Where to Watch', style: TextStyle(fontSize: 14,color:Color.fromARGB(255, 35, 97, 67), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: providers.map((p) {
            final logoUrl = 'https://image.tmdb.org/t/p/w92${p['logo_path']}';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(logoUrl, width: 50),
                Text(p['provider_name'], style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    ),
  ),
  loading: () => Center(child: const CircularProgressIndicator()),
  error: (_, __) => const Text("Watch providers not found"),
),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.movie.overview,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(fontSize: 14),
            ),
          ),

          recommended.when(
            data: (recommendedMovies) {
              if (recommendedMovies.isEmpty) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MovieCarousel(
                  title: "Recommended Movies",
                  movies: recommendedMovies,
                  onTap: (movie) async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TestDetailsScreen(movieId: movie.id, movie: movie),
                      ),
                    );
                  }, seeAll: 'Recommended Movies',
                ),
              );
            },
            error: (e, _) => const Center(child: Text("Error occurred")),
            loading: () => const Center(child: MovieCarouselShimmer()),
          ),
          const SizedBox(height: 24),
          similar.when(
            data: (recommendedMovies) {
              if (recommendedMovies.isEmpty) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: MovieCarousel(
                  title: "Movies With A Similar Vibe",
                  movies: recommendedMovies,
                  onTap: (movie) async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TestDetailsScreen(movieId: movie.id, movie: movie),
                      ),
                    );
                  }, seeAll: 'Similar Movies',
                ),
              );
            },
            error: (e, _) => const Center(child: Text("Error occurred")),
            loading: () => const Center(child:MovieCarouselShimmer()),
          ),
        ],
      ),
    );
  }
}
