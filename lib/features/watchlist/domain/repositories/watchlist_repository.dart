import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/domain/entities/watchlist_entity.dart';

abstract class WatchlistRepository {
  Future<List<WatchlistEntity>> fetchAll();
  Future<void> addMovie(String watchlistId, MovieEntity movie);
  Future<void> create(String name, MovieEntity movie);
  Future<void> removeMovie(String watchlistId, int movieId);
}
