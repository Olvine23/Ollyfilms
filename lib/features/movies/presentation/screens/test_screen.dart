import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_app/features/movies/data/datasource/test_service.dart';
import 'package:movie_app/features/movies/data/models/test_movie.dart';
import 'package:movie_app/features/movies/presentation/screens/gemini_recommeder.dart';
import 'package:movie_app/features/movies/presentation/screens/test_details_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<List<TestMovie>> moviesFuture;

  

  @override
  void initState() {
    super.initState();
    moviesFuture = TestApi().fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.tips_and_updates, size: 30, color: Colors.indigo,),
        onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => GeminiRecommendationsScreen() )), ),
      appBar: AppBar(
        title: Text("OLLYFILMS",style: TextStyle(),),
        
      ),
      body: FutureBuilder(
        future: moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            return Text('An error occured ${snapshot.error}');
          } else {
            final movies = snapshot.data;

            return ListView.builder(
              itemCount: movies?.length,
              itemBuilder: (context, index) {
                final movie = movies?[index];
                print(movie);

                return GestureDetector(
                   
                  
                  child: ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie!.posterPath}',
                      width: 50,
                      fit: BoxFit.cover,
                    ),

                    title: Text(movie!.title),
                    subtitle: Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
