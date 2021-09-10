class Movie {
  int? movieId;
  String? movieTitle;
  String? movieDescription;
  String? movieRelease;
  double? movieRate;
  String? movieCategory;
  int? movieDuration;
  String? moviePoster;
  String? movieBackground;

  Movie({
    this.movieId,
    this.movieTitle,
    this.movieDescription,
    this.movieRelease,
    this.movieRate,
    this.movieCategory,
    this.movieDuration,
    this.moviePoster,
    this.movieBackground,
  });

  Map<String, dynamic> toMap() {
    return {
      'movieId': this.movieId,
      'movieTitle': this.movieTitle,
      'movieDescription': this.movieDescription,
      'movieRelease': this.movieRelease,
      'movieRate': this.movieRate,
      'movieCategory': this.movieCategory,
      'movieDuration': this.movieDuration,
      'moviePoster': this.moviePoster,
      'movieBackground': this.movieBackground,
    };
  }

  Movie.fromMap(Map<String, dynamic> map) {
    this.movieId = map['movieId'];
    this.movieTitle = map['movieTitle'];
    this.movieDescription = map['movieDescription'];
    this.movieRelease = map['movieRelease'];
    this.movieRate = map['movieRate'];
    this.movieCategory = map['movieCategory'];
    this.movieDuration = map['movieDuration'];
    this.moviePoster = map['moviePoster'];
    this.movieBackground = map['movieBackground'];
  }
}
