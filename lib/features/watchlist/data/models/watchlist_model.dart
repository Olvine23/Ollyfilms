import 'package:hive/hive.dart';
import 'package:movie_app/features/movies/domain/entities/movie_entity.dart';

part 'watchlist_model.g.dart';

@HiveType(typeId: 0)
class WatchlistModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<MovieEntity> movies; // You’ll need to make MovieEntity Hive compatible too

  WatchlistModel({
    required this.id,
    required this.name,
    required this.movies,
  });
}
