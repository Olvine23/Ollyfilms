import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';

class MovieApiService {
  final Dio _dio = Dio();
  final String _apiKey =
      '75685bc164b692fb1193d72ca141c94d'; // Replace with your TMDb API key

  Future<List<MovieModel>> fetchNowPlaying() async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/now_playing',
      queryParameters: {'api_key': _apiKey},
    );

    final results = response.data['results'] as List;

    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<List<MovieModel>> fetchPopularMovies() async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {'api_key': _apiKey},
    );
    final results = response.data['results'] as List;
    print(results);
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  //movie reccomendations
  Future<List<MovieModel>> fetchRecommendations(int movieId) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/$movieId/recommendations',
      queryParameters: {'api_key': _apiKey},
    );

    final results = response.data["results"] as List;

    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  //get similar movies
  Future<List<MovieModel>> fetchSimilar(int movieId) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/$movieId/similar',
      queryParameters: {'api_key': _apiKey},
    );

    final results = response.data["results"] as List;

    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<List<MovieModel>> fetchTopRated() async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/top_rated',
      queryParameters: {'api_key': _apiKey},
    );
    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  // 🔍 Search movies
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/search/movie',
      queryParameters: {'api_key': _apiKey, 'query': query},
    );
    final results = response.data['results'] as List;
    log(results.toString());
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  // 🎯 Get movie details by ID
  Future<MovieModel> fetchMovieDetails(int movieId) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/$movieId',
      queryParameters: {'api_key': _apiKey},
    );
    return MovieModel.fromJson(response.data);
  }

  // 📂 Get all genres
  Future<List<Genre>> fetchGenres() async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/genre/movie/list',
      queryParameters: {'api_key': _apiKey},
    );
    final genres = response.data['genres'] as List;
    return genres.map((json) => Genre.fromJson(json)).toList();
  }

  // 🧠 Movies by Genre
  Future<List<MovieModel>> fetchMoviesByGenre(int genreId) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/discover/movie',
      queryParameters: {'api_key': _apiKey, 'with_genres': genreId.toString()},
    );
    final results = response.data['results'] as List;
    return results.map((json) => MovieModel.fromJson(json)).toList();
  }

  //fetch trailer key
  Future<String?> fetchTrailerKey(int movieId) async {
    final response = await _dio.get(
      'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey',
    );
    final data = json.decode(response.data);
    final trailers = data['results']
        .where(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        )
        .toList();

    if (trailers.isNotEmpty) {
      return trailers[0]['key'];
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getYoutubeVideos(
    int id,
    bool isMovie,
  ) async {
    final baseUrl = isMovie ? 'movie' : 'tv';
    final url =
        'https://api.themoviedb.org/3/$baseUrl/$id/videos?api_key=$_apiKey';

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);

    final allVideos = (data['results'] as List)
        .where((video) => video['site'] == 'YouTube')
        .cast<Map<String, dynamic>>()
        .toList();

    return allVideos;
  }

  String? getMainTrailerKey(List<Map<String, dynamic>> videos) {
    final trailer = videos.firstWhere(
      (v) => v['type'] == 'Trailer',
      orElse: () => {},
    );

    return trailer['key'];
  }
}
