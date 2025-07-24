import 'package:movie_app/features/movies/data/datasource/movie_api_service.dart';
import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService apiService;

  MovieRepositoryImpl(this.apiService);

  @override
  Future<List<MovieEntity>> getNowPlaying() async {
    final models = await apiService.fetchNowPlaying();
    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieEntity>> getSimilar(int movieId) async {
    final models = await apiService.fetchSimilar(movieId);

    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieEntity>> search(String query) async {
    final models = await apiService.searchMovies(query);

    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieEntity>> getRecommended(int movieId) async {
    final models = await apiService.fetchRecommendations(movieId);

    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieEntity>> getTopRated() async {
    final models = await apiService.fetchTopRated();
    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<MovieEntity>> getPopularMovies() async {
    final models = await apiService.fetchPopularMovies();
    return models
        .map(
          (m) => MovieEntity(
            id: m.id,
            title: m.title,
            overview: m.overview,
            posterUrl: 'https://image.tmdb.org/t/p/w500${m.posterPath}',
          ),
        )
        .toList();
  }

  @override
  Future<List<Genre>> getMovieGenres() async {
    final models = await apiService.fetchGenres();
    return models.map((m) => Genre(id: m.id, name: m.name)).toList();
  }
}
