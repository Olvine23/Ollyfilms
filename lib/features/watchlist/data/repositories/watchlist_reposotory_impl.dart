// lib/features/watchlist/data/watchlist_repository_impl.dart

import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:movie_app/features/watchlist/domain/repositories/watchlist_repository.dart';
 
import 'package:uuid/uuid.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final List<WatchlistEntity> _watchlists = [];
  final _uuid = const Uuid();

  @override
  Future<List<WatchlistEntity>> fetchAll() async {
    return _watchlists;
  }

  @override
  Future<void> create(String name, MovieEntity movie) async {
    final newWatchlist = WatchlistEntity(
      id: _uuid.v4(),
      name: name,
      movies: [movie],
    );
    _watchlists.add(newWatchlist);
  }

  @override
  Future<void> addMovie(String watchlistId, MovieEntity movie) async {
    final watchlist = _watchlists.firstWhere(
      (w) => w.id == watchlistId,
      orElse: () => throw Exception("Watchlist not found"),
    );

    final alreadyExists = watchlist.movies.any((m) => m.id == movie.id);
    if (!alreadyExists) {
      watchlist.movies.add(movie);
    }
  }

  @override
  Future<void> removeMovie(String watchlistId, int movieId) async {
    final watchlist = _watchlists.firstWhere(
      (w) => w.id == watchlistId,
      orElse: () => throw Exception("Watchlist not found"),
    );

    watchlist.movies.removeWhere((m) => m.id == movieId);
  }
}
