class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.example.com';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const String booksPath = '/books';
  static const String categoriesPath = '/categories';
  static const String searchPath = '/books/search';
}
