import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIRecommenderService {
  final String geminiApiKey = 'AIzaSyA_yQUb5_vQRiq3qZ5gnlFSmqz9NHvowpQ';
  final String tmdbApiKey = '75685bc164b692fb1193d72ca141c94d';

  final GenerativeModel _model;

  AIRecommenderService()
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: 'AIzaSyA_yQUb5_vQRiq3qZ5gnlFSmqz9NHvowpQ',
        );

  // Step 1: Ask Gemini to give 3-5 movie or show titles
  Future<List<String>> getTitlesFromGemini(String userPrompt) async {
    final prompt = Content.text(
      "Give me 3 to 10 movie or TV show titles based on this: $userPrompt. Just return titles as a numbered list.",
    );

    final response = await _model.generateContent([prompt]);
    final raw = response.text ?? '';

    final lines = raw
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '')) // remove numbers
        .toList();

    return lines;
  }

  // Step 2: Search TMDB for each title
  Future<List<Map<String, dynamic>>> searchTitlesOnTMDB(List<String> titles) async {
    List<Map<String, dynamic>> results = [];

    for (final title in titles) {
      final url =
          'https://api.themoviedb.org/3/search/multi?api_key=$tmdbApiKey&query=${Uri.encodeComponent(title)}';

      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        results.add(data['results'][0]); // first match
      }
    }

    return results;
  }

  // Combo: From prompt → titles → TMDB search results
  Future<List<Map<String, dynamic>>> getMovieRecommendations(String userPrompt) async {
    final titles = await getTitlesFromGemini(userPrompt);
    final results = await searchTitlesOnTMDB(titles);
    return results;
  }
}
