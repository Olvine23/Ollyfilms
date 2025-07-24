import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/data/datasource/ai_recommender.dart';
 
 

class GeminiRecommendationsScreen extends StatefulWidget {
  @override
  _GeminiRecommendationsScreenState createState() => _GeminiRecommendationsScreenState();
}

class _GeminiRecommendationsScreenState extends State<GeminiRecommendationsScreen> {
  final AIRecommenderService _ai = AIRecommenderService();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = false;

  void _getRecommendations() async {
    setState(() => _isLoading = true);
    final results = await _ai.getMovieRecommendations(_controller.text);
    setState(() {
      _recommendations = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Movie Assistant")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "e.g. Funny shows like Brooklyn Nine-Nine",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _getRecommendations,
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _recommendations.length,
                      itemBuilder: (context, index) {
                        final item = _recommendations[index];
                        final title = item['title'] ?? item['name'];
                        final overview = item['overview'];
                        final poster = item['poster_path'];

                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: poster != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w200$poster',
                                    width: 60,
                                  )
                                : null,
                            title: Text(title ?? 'Unknown'),
                            subtitle: Text(
                              overview != null && overview.length > 100
                                  ? '${overview.substring(0, 100)}...'
                                  : overview ?? 'No description',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
