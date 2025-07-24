import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getNowPlaying();
   
  Future<List<MovieEntity>> getPopularMovies();

  Future<List<Genre>> getMovieGenres();

  Future<List<MovieEntity>> getTopRated();
}
