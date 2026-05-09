/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// Base URL for JSONPlaceholder API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// API Endpoints
  static const String postsEndpoint = '/posts';

  /// Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection';
  static const String serverErrorMessage =
      'Server error occurred. Please try again later';
  static const String unknownErrorMessage = 'An unexpected error occurred';
}
