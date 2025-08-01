import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getNowPlaying();
   
  Future<List<MovieEntity>> getPopularMovies();

  Future<List<Genre>> getMovieGenres();

  Future<List<MovieEntity>> getTopRated();

  Future<List<MovieEntity>> getRecommended(int movieId);

   Future<List<MovieEntity>> getSimilar(int movieId);

   Future<List<MovieEntity>> search(String query);

    Future<List<MovieEntity>> getMoviesByGenre(int genreId);

      Future<List<Map<String, dynamic>>> getWatchProviders(int movieId, String countryCode);


    


}
