import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/domain/entities/watchlist_entity.dart';

abstract class LocalWatchlistDatasource {
  Future<List<WatchlistEntity>> getAll();
  Future<void> saveWatchlist(WatchlistEntity watchlist);
  Future<void> deleteMovieFromWatchlist(String watchlistId, int movieId);
  Future<void> createWatchlist(String name, MovieEntity movie);
}
