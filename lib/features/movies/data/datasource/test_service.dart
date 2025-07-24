import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/data/models/test_movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/movies/presentation/screens/test_details_screen.dart';

class TestApi{

  final String _apiKey =  '75685bc164b692fb1193d72ca141c94d';

  Future<List<TestMovie>> fetchPopularMovies() async {

    final response = await http.get( Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey'));
    if(response.statusCode == 200){

      final data = json.decode(response.body);

      final List results = data['results'];

      return results.map((movie) => TestMovie.fromJson(movie)).toList();

    }else{
      throw Exception("Failed to fetch");
    }

  }

  Future<String?> fetchTrailerKey(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey'));
    final data = json.decode(response.body);
    final trailers = data['results']
        .where((video) =>
            video['type'] == 'Trailer' && video['site'] == 'YouTube')
        .toList();

         if (trailers.isNotEmpty) {
      return trailers[0]['key'];
    }
    return null;


  }

  Future<List<Map<String, dynamic>>> getYoutubeVideos(int id, bool isMovie) async {
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

// void openDetailScreen(BuildContext context, int movieId , TestMovie movie) async{
//      final trailerKey = await  TestApi().fetchTrailerKey(movieId);
//        final allVideos = await TestApi().getYoutubeVideos(movieId, true);
//        final mainKey  =  await TestApi().getMainTrailerKey(allVideos);
//     if (mainKey != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => TestDetailsScreen(youtubeKey:mainKey, movie: movie, videos: allVideos, initialKey: mainKey,),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Trailer not available")),
//       );
//     }


//   }

  

}