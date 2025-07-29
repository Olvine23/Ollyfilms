import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}

 extension MovieHelpers on MovieEntity {
  String get fullPosterUrl {
    final url = posterUrl;

    if (url == null || url.isEmpty || url == 'null') {
      return 'https://via.placeholder.com/150';
    }

    // Don't double-append if it's already a full URL
    if (url.startsWith('http')) {
      return url;
    }

    return 'https://image.tmdb.org/t/p/w500$url';
  }
}
