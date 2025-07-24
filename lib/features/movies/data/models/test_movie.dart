class TestMovie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  TestMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory TestMovie.fromJson(Map<String, dynamic> json) {
    return TestMovie(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
    );
  }
}
