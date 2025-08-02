import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/features/watchlist/application/providers/watchlist_provider.dart';
import 'package:movie_app/features/watchlist/presentation/screens/watchlist_screen.dart' show ViewWatchList;

class WatchlistScreen extends ConsumerWidget {

  
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(watchlistProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      
      ),
     appBar: AppBar(title: Text("Watchlists"),),
      body: ListView(
        children: lists.map((list) => ListTile(
          leading: Icon(Icons.movie),
            title: Row(
                children: [
                  Text(list.name,style: Theme.of(context).textTheme.titleMedium,),
                  SizedBox(width: 8,),
                  CircleAvatar(
                    radius: 10,
                    child: Text(list.movies.length.toString(), style: Theme.of(context).textTheme.bodySmall,))
                ],
              ),
           trailing: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewWatchList(movies: list.movies,)));
            }, child:Text("Open Watchlist")),
          // title: Text(list.name),
        )).toList(),
      ),


    );
  }
}
