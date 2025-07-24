import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerPlayer extends ConsumerStatefulWidget {
  final int movieId;
  final String posterUrl;

  const MovieTrailerPlayer({
    super.key,
    required this.movieId,
    required this.posterUrl,
  });

  @override
  ConsumerState<MovieTrailerPlayer> createState() => _MovieTrailerPlayerState();
}

class _MovieTrailerPlayerState extends ConsumerState<MovieTrailerPlayer> {
  YoutubePlayerController? _controller;
  bool isLoading = false;
  bool showPlayer = false;
  String? error;

  Future<void> _loadTrailer() async {
    setState(() => isLoading = true);
    try {
      final key = await ref.read(mainTrailerKey(widget.movieId).future);
      if (key == null) {
        setState(() => error = "Trailer not available.");
        return;
      }

      _controller = YoutubePlayerController(
        initialVideoId: key,
        flags: const YoutubePlayerFlags(autoPlay: true),
      );

      setState(() => showPlayer = true);
    } catch (e) {
      setState(() => error = "Failed to load trailer.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showPlayer && _controller != null)
            YoutubePlayer(controller: _controller!)
          else
            Image.network('https://image.tmdb.org/t/p/w780${widget.posterUrl}', fit: BoxFit.cover),

          if (!showPlayer && !isLoading)
            Center(
              child: IconButton(
                icon: const Icon(Icons.play_circle, size: 64, color: Colors.white),
                onPressed: _loadTrailer,
              ),
            ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),

          if (error != null)
            Center(child: Text(error!, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
