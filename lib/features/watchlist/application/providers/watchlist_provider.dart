import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:movie_app/features/watchlist/data/repositories/watchlist_hive_impl.dart';
import 'package:movie_app/features/watchlist/data/repositories/watchlist_reposotory_impl.dart';
import 'package:movie_app/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:movie_app/features/watchlist/domain/repositories/watchlist_repository.dart';


final watchListRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepositoryImpl(); // simple in-memory version
});

final hiveWatchlistRepoProvider = Provider<WatchlistRepository>((ref) {
  final box = Hive.box<WatchlistModel>('watchlists');
  return WatchlistRepositoryImplHive(box);
});


final watchlistProvider = StateNotifierProvider<WatchlistNotifier, List<WatchlistEntity>>(
  (ref) => WatchlistNotifier(ref.read(watchListRepositoryProvider)),
);

class WatchlistNotifier extends StateNotifier<List<WatchlistEntity>> {
  final WatchlistRepository _repo;

  WatchlistNotifier(this._repo) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await _repo.fetchAll();
  }

  Future<void> create(String name, MovieEntity movie) async {
    await _repo.create(name, movie);
    await load();
  }

  Future<void> addMovie(String listId, MovieEntity movie) async {
    await _repo.addMovie(listId, movie);
    await load();
  }

  Future<void> remove(String listId, int movieId) async {
    await _repo.removeMovie(listId, movieId);
    await load();
  }
}
