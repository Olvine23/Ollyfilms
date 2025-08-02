import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class MovieEntity extends HiveObject {
   @HiveField(0)
  final int id;
   @HiveField(1)
  final String title;
   @HiveField(2)
  final String overview;
   @HiveField(3)
  final String posterUrl;

  MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
  });
}