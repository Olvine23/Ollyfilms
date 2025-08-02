import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';
import 'package:movie_app/features/watchlist/application/providers/watchlist_provider.dart';
import 'package:movie_app/features/watchlist/presentation/screens/watchlist_screen.dart';

class WatchlistSheet extends ConsumerWidget {
  final MovieEntity movie;

  const WatchlistSheet({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final watchlistsAsync = ref.watch(watchlistProvider);
    final lists = ref.watch(watchlistProvider);




    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add ${movie.title} to Watchlist",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ...lists.map((list) => ListTile(
            trailing: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewWatchList(movies: list.movies,)));
            }, child:Text("Open Watchlist")),
            // trailing:Text( list.movies.length.toString()),
              title: Row(
                children: [
                  Text(list.name,style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(width: 8,),
                  CircleAvatar(
                    radius: 10,
                    child: Text(list.movies.length.toString(), style: Theme.of(context).textTheme.bodySmall,))
                ],
              ),
              onTap: () {
                ref.read(watchlistProvider.notifier).addMovie(list.id, movie);
                  final snackBar = SnackBar(
                 
                    behavior: SnackBarBehavior.floating,
                     shape: StadiumBorder(),
                    // duration: Duration(seconds: 2),
                    backgroundColor: Colors.greenAccent,
                content:  Text('Added ${movie.title} to ${list.name}', style: Theme.of(context).textTheme.titleMedium !.copyWith(color: Colors.black87),),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {
                    // Code to execute when the action is pressed
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              },
            )),
          // watchlistsAsync.when(
          //   data: (lists) => ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: lists.length,
          //     itemBuilder: (context, index) {
          //       final list = lists[index];
          //       final containsMovie = list.movies.any((m) => m.id == movie.id);
          //       return ListTile(
          //         title: Text(list.name),
          //         trailing: containsMovie
          //             ? IconButton(
          //                 icon: const Icon(Icons.remove_circle),
          //                 onPressed: () {
          //                   ref
          //                       .read(watchlistProvider.notifier)
          //                       .remove(list.id, movie.id);
          //                   Navigator.pop(context);
          //                 },
          //               )
          //             : IconButton(
          //                 icon: const Icon(Icons.add_circle),
          //                 onPressed: () {
          //                   ref
          //                       .read(watchlistProvider.notifier)
          //                       .addMovie(list.id, movie);
          //                   Navigator.pop(context);
          //                 },
          //               ),
          //       );
          //     },
          //   ),
          //   loading: () => const CircularProgressIndicator(),
          //   error: (e, _) => Text("Failed to load watchlists: $e"),
          // ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Create new watchlist'),
              onTap: () {
                _showCreateDialog(context, ref);
                // Navigator.pop(context);
                // showDialog(
                //   context: context,
                //   builder: (_) => CreateWatchlistDialog(movie: movie),
                // );
              },
            ),
          )
        ],
      ),
    );
  }

   void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Watchlist"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Watchlist name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref
                    .read(watchlistProvider.notifier)
                    .create(name, movie);
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close bottomsheet
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  
}
