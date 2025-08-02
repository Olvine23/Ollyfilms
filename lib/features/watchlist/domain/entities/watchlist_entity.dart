import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

class WatchlistEntity {
  final String id;
  final String name;
  final List<MovieEntity> movies;

  WatchlistEntity({
    required this.id,
    required this.name,
    required this.movies,
  });
}