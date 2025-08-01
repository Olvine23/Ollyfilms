import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_card.dart';

class SeeAllScreen extends StatefulWidget {
  final String title;
  final List<MovieEntity> movies;
  final void Function(MovieEntity) onTap;

  /// Optional for infinite scrolling
  final VoidCallback? onLoadMore;

  const SeeAllScreen({
    super.key,
    required this.title,
    required this.movies,
    required this.onTap,
    this.onLoadMore,
  });

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        widget.onLoadMore?.call(); // trigger pagination if available
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.movies.length.toString());
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: widget.movies.isEmpty
          ? const Center(child: Text("No movies found."))
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: widget.movies.length,
              itemBuilder: (_, index) {
                final movie = widget.movies[index];
                return GestureDetector(
                  onTap: () => widget.onTap(movie),
                  child: MovieCard(movie: movie),
                );
              },
            ),
    );
  }
}
