import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
 
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TestDetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final MovieEntity movie;

  const TestDetailsScreen({super.key, required this.movieId, required this.movie});

  @override
  ConsumerState<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends ConsumerState<TestDetailsScreen> {

  YoutubePlayerController? _controller;
  @override
  Widget build(BuildContext context) {
    final allVideosAsync = ref.watch(youTubeVideosProvider(widget.movieId));
    final mainKeyAsync = ref.watch(mainTrailerKey(widget.movieId));
    print(allVideosAsync);

     void _playVideo(String newKey) {
    _controller?.load(newKey);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

   YoutubePlayerController _buildController(String key) {
    return YoutubePlayerController(
      initialVideoId: key,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: mainKeyAsync.when(
        
        data: (key) {
          if (key == null) {
            return const Center(child: Text("Trailer not available"));
          }

             // Init controller only once
          if (_controller == null) {
            _controller = _buildController(key);
          }
        

          return Column(
            children: [
                YoutubePlayer(controller: _controller!),
                Text(widget.movie.overview),
              // You can use any YouTube player widget here.
              // allVideosAsync.when(
              //   data: (videos) => Expanded(
              //     child: ListView.builder(
              //       itemCount: videos.length,
              //       itemBuilder: (_, index) {
              //         final video = videos[index];
              //         final key = video['key'];
              //         return ListTile(
              //           title: Text(video['name'] ?? 'Unnamed'),
              //           subtitle: Text(video['type']),
              //           onTap: () => _playVideo(key),
              //         );
              //       },
              //     ),
              //   ),
              //   loading: () => const CircularProgressIndicator(),
              //   error: (e, _) => Text("Error loading all videos: $e"),
              // ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error fetching trailer: $e")),
      ),
    );
  }
}
