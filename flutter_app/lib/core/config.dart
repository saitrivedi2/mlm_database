class AppConfig {
  // Base URL of your backend deployment
  static const String baseUrl = 'https://mlm-database.onrender.com';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
