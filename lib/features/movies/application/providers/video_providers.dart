import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/data/datasource/movie_api_service.dart';

final apiServiceProvider = Provider((ref) => MovieApiService());

final youTubeVideosProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((
      ref,
      movieId,
    ) async {
      final api = ref.read(apiServiceProvider);
      return api.getYoutubeVideos(movieId, true);
    });

final mainTrailerKey = FutureProvider.family<String?, int>((
  ref,
  movieId,
) async {
  final api = ref.read(apiServiceProvider);
  final videos = await api.getYoutubeVideos(movieId, true);
  return api.getMainTrailerKey(videos);
});
