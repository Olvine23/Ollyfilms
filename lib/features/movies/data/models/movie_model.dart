import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
abstract class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}
