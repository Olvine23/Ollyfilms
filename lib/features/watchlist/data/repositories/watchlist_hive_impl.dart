import 'package:hive/hive.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:movie_app/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:movie_app/features/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImplHive implements WatchlistRepository {
  final Box<WatchlistModel> _box;

  WatchlistRepositoryImplHive(this._box);

  @override
  Future<void> create(String name, MovieEntity movie) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newList = WatchlistModel(id: id, name: name, movies: [movie]);
    await _box.put(id, newList);
  }

  @override
  Future<List<WatchlistEntity>> fetchAll() async {
    return _box.values
        .map((e) => WatchlistEntity(id: e.id, name: e.name, movies: e.movies))
        .toList();
  }

  @override
  Future<void> addMovie(String watchlistId, MovieEntity movie) async {
    final list = _box.get(watchlistId);
    if (list == null) return;
    if (!list.movies.any((m) => m.id == movie.id)) {
      list.movies.add(movie);
      await list.save();
    }
  }

  @override
  Future<void> removeMovie(String watchlistId, int movieId) async {
    final list = _box.get(watchlistId);
    if (list == null) return;
    list.movies.removeWhere((m) => m.id == movieId);
    await list.save();
  }
}
