import 'package:freezed_annotation/freezed_annotation.dart';
part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  
  // @override
  // // TODO: implement id
  // int get id => throw UnimplementedError();
  
  // @override
  // // TODO: implement name
  // String get name => throw UnimplementedError();
  
  // @override
  // Map<String, dynamic> toJson() {
  //   // TODO: implement toJson
  //   throw UnimplementedError();
  // }
}