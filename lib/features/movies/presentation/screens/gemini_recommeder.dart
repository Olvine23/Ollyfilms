import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/features/movies/data/datasource/ai_recommender.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/movie_details.dart';

class GeminiRecommendationsScreen extends StatefulWidget {
  const GeminiRecommendationsScreen({super.key});

  @override
  State<GeminiRecommendationsScreen> createState() => _GeminiRecommendationsScreenState();
}

class _GeminiRecommendationsScreenState extends State<GeminiRecommendationsScreen> {
  final AIRecommenderService _ai = AIRecommenderService();
  final TextEditingController _controller = TextEditingController();

  List<MovieEntity> _recommendations = [];
  bool _isLoading = false;

  final List<String> suggestions = [
    "Sad Romance",
    "Shows like Suits ⚖️",
    "Feel-good romcoms 💕",
    "Scary but fun 👻",
    "Teen drama 🍿",
    "Nostalgic animations"
  ];

  void _getRecommendations(String query) async {
    if (query.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _recommendations = [];
    });

    final result = await _ai.getMovieRecommendations(query);
    final movies = result.map<MovieEntity>((item) {
      return MovieEntity(
        id: item['id'],
        title: item['title'] ?? item['name'] ?? 'Untitled',
        overview: item['overview'] ?? 'No description.',
        posterUrl: item['poster_path'] ?? "https://blocks.astratic.com/img/general-img-landscape.png",
      );
    }).toList();

    setState(() {
      _recommendations = movies;
      _isLoading = false;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("🎬 AI Movie Assistant"),
        centerTitle: true,
        backgroundColor:  Color.fromARGB(255, 52, 128, 110),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 💬 Greeting and Smart Suggestions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color.fromARGB(255, 52, 128, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What are you in the mood for? 👇",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: suggestions.map((s) {
                    return ActionChip(
                      // backgroundColor: Colors.white,
                      label: Text(s),
                      onPressed: () {
                        _controller.text = s;
                        _getRecommendations(s);
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),

          // 🎬 Movie List
          Expanded(
            child: _isLoading
                ?  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Give me a sec ... ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Center(child:Lottie.asset('assets/ailoading.json')),
                  ],
                )
                : _recommendations.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "What do you feel like watching? I got you 😉",
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        itemCount: _recommendations.length,
                        itemBuilder: (_, index) {
                          final movie = _recommendations[index];
                          return Card(
                            surfaceTintColor: Colors.lightGreenAccent,
                            shadowColor: Colors.greenAccent,
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TestDetailsScreen(
                                      movieId: movie.id,
                                      movie: movie,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  // 🖼 Poster
                                  if (movie.posterUrl != null)
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w200${movie.posterUrl}',
                                      width: 100,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                    )
                                  else
                                    Container(
                                      width: 100,
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  // 📖 Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            movie.overview.length > 120
                                                ? '${movie.overview.substring(0, 120)}...'
                                                : movie.overview,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // 💬 Bottom Input
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _getRecommendations,
                      decoration: InputDecoration(
                        hintText: "Try 'Mind-bending thrillers'...",
                        filled: true,
                        // fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                   backgroundColor:  Color.fromARGB(255, 52, 128, 110),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.greenAccent),
                      onPressed: () => _getRecommendations(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
