import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

class PaginatedMovieNotifier extends StateNotifier<List<MovieEntity>> {
  final Future<List<MovieEntity>> Function(int page) fetchPage;
  int _currentPage = 1;
  bool _isLoading = false;

  PaginatedMovieNotifier(this.fetchPage) : super([]) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (_isLoading) return;
    _isLoading = true;
    final newMovies = await fetchPage(_currentPage);
    state = [...state, ...newMovies];
    _currentPage++;
    _isLoading = false;
  }

  Future<void> refresh() async {
    _currentPage = 1;
    final newMovies = await fetchPage(_currentPage);
    state = newMovies;
    _currentPage++;
  }
}
