import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/movie_provider.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_carousel.dart';
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

 void _playVideo(String newKey){
  _controller?.load(newKey);
 }
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
          flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommended = ref.watch(recommendedProvider(widget.movieId));

    final relatedVideos =  ref.watch(youTubeVideosProvider(widget.movieId));

    print(relatedVideos);

    final similar  =ref.watch(similarMoviesProvider(widget.movieId));

    return Scaffold(
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
                  SizedBox.expand(child: YoutubePlayer(controller: _controller!))
                else
                  Image.network(
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
                      icon: const Icon(Icons.play_circle, size: 64, color: Colors.greenAccent),
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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.movie.overview,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
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
                    final key = await ref.read(mainTrailerKey(movie.id));
                    Navigator.pushReplacement(
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
              );
            },
            error: (e, _) => const Center(child: Text("Error occurred")),
            loading: () => const Center(child: CircularProgressIndicator()),
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
                    final key = await ref.read(mainTrailerKey(movie.id));
                    Navigator.pushReplacement(
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
              );
            },
            error: (e, _) => const Center(child: Text("Error occurred")),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),

  //         relatedVideos.when(data: (vid){
  //           if(vid.isEmpty) return SizedBox();
  //           return ListView.builder(
  //             shrinkWrap: true,
  // physics: NeverScrollableScrollPhysics(),
  //             itemCount: vid.length,
  //             itemBuilder: (context, index){
  //                log(vid[index].toString());
  //             return ListTile(
  //               onTap:() => _playVideo(vid[index]['key']),
  //               title: Text(vid[index]['name']), );
  //           });
  //         }, error: (e,_) => Center(child: Center(child: Text("An error occured $e"),),), loading: () => Center(child: CircularProgressIndicator(),))

        ],
      ),
    );
  }
}
