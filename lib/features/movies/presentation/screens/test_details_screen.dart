// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:movie_app/features/movies/data/models/test_movie.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class TestDetailsScreen extends StatefulWidget {
//   const TestDetailsScreen({
//     // super.key,
//     required this.movie,
//     required this.youtubeKey, required this.videos, required this.initialKey,
//   });

//   final TestMovie movie;
//   final String youtubeKey;
//    final List<Map<String, dynamic>> videos;
//      final String initialKey;

//   @override
//   State<TestDetailsScreen> createState() => _TestDetailsScreenState();
// }

// class _TestDetailsScreenState extends State<TestDetailsScreen> {
//   late YoutubePlayerController _controller;
  

//   @override
//   void initState() {
//     super.initState();
//     _controller = _buildController(widget.initialKey);
//   }

//    YoutubePlayerController _buildController(String key) {
//     return YoutubePlayerController(
//       initialVideoId: key,
//       flags: YoutubePlayerFlags(autoPlay: true, mute: false),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _playVideo(String newKey) {
//     _controller.load(newKey);
//   }

//   @override
//   Widget build(BuildContext context) {
//      final related = widget.videos
//         .where((v) => v['site'] == 'YouTube' && v['key'] != widget.initialKey)
//         .toList();
//     return SafeArea(
//       child: Scaffold(
      
//         body:  Column(children: [
//           YoutubePlayer(controller: _controller),

//           Text(widget.movie.overview),
//              Expanded(
//             child: ListView.builder(
//               itemCount: related.length,
//               itemBuilder: (context, index) {
//                 final video = related[index];
//                 final title = video['name'];
//                 final key = video['key'];
//                 final thumbnailUrl = 'https://img.youtube.com/vi/$key/0.jpg';

//                 return ListTile(
//                   leading: Image.network(thumbnailUrl, width: 100),
//                   title: Text(title ?? "Untitled"),
//                   trailing: Icon(Icons.play_arrow),
//                   onTap: () {
//                     _playVideo(key);
//                   },
//                 );
//               },
//             ),
//           )
//         ],)
//       ),
//     );
//   }
// }
