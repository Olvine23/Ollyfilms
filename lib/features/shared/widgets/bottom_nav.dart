import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/data/models/genre.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/movies/presentation/movie_details.dart';
import 'package:movie_app/features/movies/presentation/screens/explore/explore_screen.dart';
import 'package:movie_app/features/movies/presentation/screens/homescreen.dart';
import 'package:movie_app/features/movies/presentation/screens/settings/settings_screen.dart';
import 'package:movie_app/features/movies/presentation/screens/watchlist/watclist_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      ExploreScreen(
        onMovieTap: (MovieEntity movie) {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return TestDetailsScreen(movieId: movie.id, movie: movie);
          }));
        },
      ),
      WatchlistScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.search), label: "Explore"),
          NavigationDestination(icon: Icon(Icons.bookmark), label: "Watchlist"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
