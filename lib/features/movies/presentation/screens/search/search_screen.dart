import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/features/movies/application/providers/movie_provider.dart';
import 'package:movie_app/features/movies/presentation/movie_details.dart';

class MovieSearchScreen extends ConsumerStatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  ConsumerState<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends ConsumerState<MovieSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchMoviesProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Search movies...",
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            setState(() {
              query = value;
            });
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: query.isEmpty
          ? const Center(child: Text("Start typing to search..."))
          : searchResults.when(
              data: (movies) => ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  print(movie);

                  return ListTile(
                    // leading: Image.network(
                    //   'https://image.tmdb.org/t/p/w92${movie.posterUrl}',
                    //   fit: BoxFit.cover,
                    // ),
                    // title: Text(movie.title),
                    // onTap: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => TestDetailsScreen(
                    //       movieId: movie.id,
                    //       movie: movie,
                    //     ),
                    //   ),
                    // ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
    );
  }
}
