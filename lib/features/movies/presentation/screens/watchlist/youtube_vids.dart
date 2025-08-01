import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/providers/video_providers.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeDetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final MovieEntity movie;

  const YouTubeDetailsScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  @override
  ConsumerState<YouTubeDetailsScreen> createState() =>
      _YouTubeDetailsScreenState();
}

class _YouTubeDetailsScreenState extends ConsumerState<YouTubeDetailsScreen> {
  YoutubePlayerController? _controller;
  String? _currentVideoId;

  void _initController(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );
    _currentVideoId = videoId;
  }

  void _switchVideo(String videoId) {
    if (_controller == null) {
      _initController(videoId);
    } else {
      _controller!.load(videoId);
    }

    setState(() {
      _currentVideoId = videoId;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainTrailer = ref.watch(mainTrailerKey(widget.movieId));
    final extraVideos = ref.watch(youtubeSearchProvider(widget.movie.title));

    extraVideos.when(
      data: (videos) => log(videos.length.toString()),
      loading: () {},
      error: (e, _) {},
    );
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Build combined trailer + fallback video
          mainTrailer.when(
            data: (tmdbVideoId) {
              return extraVideos.when(
                data: (youtubeVideos) {
                  // Use trailer first, fallback to first YouTube search result
                  final fallbackVideoId = youtubeVideos.isNotEmpty
                      ? youtubeVideos[0]['videoId']
                      : null;

                  final videoIdToPlay = tmdbVideoId?.isNotEmpty == true
                      ? tmdbVideoId
                      : fallbackVideoId;

                  if (videoIdToPlay == null) {
                    return const Text("No trailer or fallback video found.");
                  }

                  if (_controller == null) {
                    _initController(videoIdToPlay);
                  }

                  return YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                    ),
                    builder: (context, player) => player,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error loading fallback videos: $e"),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text("Error loading trailer: $e"),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text("More Videos", textAlign:TextAlign.left, style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),),
          ),
          const SizedBox(height: 8),

          // Extra YouTube videos
          Expanded(
            child: extraVideos.when(
              data: (videos) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: videos.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final v = videos[index];
                  return Card(
                    surfaceTintColor: Colors.lightGreenAccent,
                    shadowColor: Colors.greenAccent,
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),

                    child: InkWell(
                      onTap: () {
                        final id = v['videoId'];
                        if (_currentVideoId != id) {
                          _switchVideo(id);
                        }
                      },
                      child: Row(
                        children: [
                            Image.network(
                                       v['thumbnail'], 
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                    ),
                                     Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v['title'],
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            v['channelTitle'],
                                            style: theme.textTheme.bodyMedium!.copyWith(color: const Color.fromARGB(255, 35, 97, 67), fontWeight: FontWeight.bold),
                                          ),
                                            const SizedBox(height: 2),
                                          Text(
                                            v['description'],
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                        ],
                      ),
                    ),
                  );

                  // return ListTile(
                  //   leading: Image.network(v['thumbnail'], width: 100),
                  //   title: Text(v['title']),
                  //   subtitle: Text(v['channelTitle']),
                  //   onTap: () {
                  //     final id = v['videoId'];
                  //     if (_currentVideoId != id) {
                  //       _switchVideo(id);
                  //     }
                  //   },
                  // );
                },
              ),
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (e, _) => Text("Error loading videos: $e"),
            ),
          ),
        ],
      ),
    );
  }
}
