import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/features/core/theme_provider.dart';
import 'package:movie_app/features/movies/presentation/screens/homescreen.dart';
import 'package:movie_app/features/shared/widgets/bottom_nav.dart';

void main() {
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode, // 👈 Controls light/dark

      theme: ThemeData(
        
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          // seedColor: Colors.blueAccent,
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme).apply( bodyColor: Colors.white,
    displayColor: Colors.white,),
      ),

      home: MainNavigation(),
    );
  }
}
