import 'package:flutter/material.dart';
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

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    WatchlistScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
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
