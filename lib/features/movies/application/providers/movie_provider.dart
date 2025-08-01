
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/application/notifiers/paginated_movie_notifier.dart';
import 'package:movie_app/features/movies/data/datasource/movie_api_service.dart';
import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository_impl.dart';

final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieApiService());
});
final nowPlayingProvider = FutureProvider<List<MovieEntity>>((ref) async{
  final repository =ref.read(movieRepositoryProvider);
  return repository.getNowPlaying();

});

final topRatedProvider  =  FutureProvider<List<MovieEntity>>((ref) async{

  final repository = ref.read(movieRepositoryProvider);

  return repository.getTopRated();

});

final movieListProvider = FutureProvider<List<MovieEntity>>((ref) async {
  final repository = ref.read(movieRepositoryProvider);
  return repository.getPopularMovies();
});
final popularMoviesNotifierProvider = StateNotifierProvider.family<PaginatedMovieNotifier, List<MovieEntity>, void>((ref, _) {
  final repository = ref.watch(movieRepositoryProvider);
  return PaginatedMovieNotifier((page) => repository.getPopularMovies(page: page));
});


final genreProvider = FutureProvider<List<Genre>>((ref) async{
  final repository = ref.read(movieRepositoryProvider);
  return repository.getMovieGenres();
});

final recommendedProvider = FutureProvider.family<List<MovieEntity>, int>((ref, movieId) async{
  final repository = ref.read(movieRepositoryProvider);

  return repository.getRecommended(movieId);
});

final similarMoviesProvider = FutureProvider.family<List<MovieEntity>, int>((ref, movieId) async{
  final repository = ref.read(movieRepositoryProvider);

  return repository.getSimilar(movieId);
});

final searchMoviesProvider = FutureProvider.family<List<MovieEntity>, String>((ref, query) async{
  final repository = ref.read(movieRepositoryProvider);

  return repository.search(query);
});

final moviesByGenreProvider = FutureProvider.family<List<MovieEntity>, int>((ref, genreId) async {
  final repo = ref.read(movieRepositoryProvider);
  return repo.getMoviesByGenre(genreId);
});


final paginatedPopularProvider = StateNotifierProvider<PaginatedMovieNotifier, List<MovieEntity>>((ref) {
  final repo = ref.read(movieRepositoryProvider);
  return PaginatedMovieNotifier((page) => repo.getPopularMovies(page: page));
});

final watchProvidersProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, movieId) async {
  final api = ref.read(movieRepositoryProvider);
  // You can replace 'KE' with dynamic region logic
  return await api.getWatchProviders(movieId, 'US');
});
