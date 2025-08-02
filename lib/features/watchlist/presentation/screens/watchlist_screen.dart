import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

class ViewWatchList extends StatelessWidget {

  final List<MovieEntity> movies;
  const ViewWatchList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index){
        return ListTile(
          title: Text(movies[index].title),
        );
      }),
    );
  }
}