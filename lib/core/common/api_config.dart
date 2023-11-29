class ApiConfig {
  static const String apiHost = 'https://api.themoviedb.org';
  static const String basePath = '/3';
  static const String movies = "$apiHost$basePath/movie";
  static const String popularMovies = "$movies/popular";

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZDc0YmFkMmZjNDkyMGZkOTcyYmEyYzM1MTQzZmE5ZCIsInN1YiI6IjY1NjQ0ZjFiZmI1Mjk5MDEwMzUxMTFiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NXOOWnOBCG1rWB0_Bfo0hdCXQcbZ8mCEVhtLtxqfu8E',
    };
  }
}
