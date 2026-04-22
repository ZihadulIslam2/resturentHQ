/// Application configuration for different environments
class AppConfig {
  /// Base URL for the API server
  /// Update this based on your deployment environment:
  /// - Development (localhost): http://localhost:5000/api
  /// - Development (Android Emulator): http://10.0.2.2:5000/api
  /// - Development (iOS Simulator): http://localhost:5000/api
  /// - Production: https://api.yourserver.com/api
  static const String apiBaseUrl = 'http://localhost:5000/api';

  /// Enable API request/response logging for debugging
  static const bool enableApiLogging = true;

  /// Request timeout in seconds
  static const int requestTimeoutSeconds = 30;
}
