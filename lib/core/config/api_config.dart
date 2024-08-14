class ApiConfig {
  static const String apiHost = 'https://api.themoviedb.org/3';
  static const String imgHost = 'https://image.tmdb.org/t/p/original';
  static const String basePath = '/discover';
  static const String movies = "/movie";
  static const String tvShows = "/tv";
  static const String genre = "$apiHost/genre";

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZDc0YmFkMmZjNDkyMGZkOTcyYmEyYzM1MTQzZmE5ZCIsInN1YiI6IjY1NjQ0ZjFiZmI1Mjk5MDEwMzUxMTFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NXOOWnOBCG1rWB0_Bfo0hdCXQcbZ8mCEVhtLtxqfu8E',
    };
  }
}
