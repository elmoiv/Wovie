const String apiUrl = 'https://api.themoviedb.org/3/';
const String movieUrl = apiUrl + 'movie/';
const String genreUrl = apiUrl + 'discover/movie/';
const String popularUrl = movieUrl + 'popular/';
const String upcomingUrl = movieUrl + 'upcoming/';
const String actorUrl = apiUrl + 'person/';
const String searchUrl = apiUrl + 'search/movie';

/// SD URLS
const String imageBackgroundUrlSD = 'https://image.tmdb.org/t/p/w300';
const String imagePosterUrlSD =
    'https://www.themoviedb.org/t/p/w220_and_h330_face';
const String imageActorUrlSD =
    'https://www.themoviedb.org/t/p/w300_and_h450_bestv2';

/// HD URLS
const String imageBackgroundUrlHD =
    'https://www.themoviedb.org/t/p/w1920_and_h800_multi_faces';
const String imagePosterUrlHD =
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2';
const String imageActorUrlHD =
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2';
const Map<int, String> genreIntStr = {
  28: 'Action',
  12: 'Adventure',
  16: 'Animation',
  35: 'Comedy',
  80: 'Crime',
  99: 'Documentary',
  18: 'Drama',
  10751: 'Family',
  14: 'Fantasy',
  36: 'History',
  27: 'Horror',
  10402: 'Music',
  9648: 'Mystery',
  10749: 'Romance',
  878: 'Science Fiction',
  10770: 'TV Movie',
  53: 'Thriller',
  10752: 'War',
  37: 'Western',
};
const Map<String, int> genreStrInt = {
  'Action': 28,
  'Adventure': 12,
  'Animation': 16,
  'Comedy': 35,
  'Crime': 80,
  'Documentary': 99,
  'Drama': 18,
  'Family': 10751,
  'Fantasy': 14,
  'History': 36,
  'Horror': 27,
  'Music': 10402,
  'Mystery': 9648,
  'Romance': 10749,
  'Science Fiction': 878,
  'TV Movie': 10770,
  'Thriller': 53,
  'War': 10752,
  'Western': 37,
};
