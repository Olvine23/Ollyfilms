
import 'package:flutter_riverpod/flutter_riverpod.dart';
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


final genreProvider = FutureProvider<List<Genre>>((ref) async{
  final repository = ref.read(movieRepositoryProvider);
  return repository.getMovieGenres();
});