import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';

/// HTTP client wrapper for making API requests
class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({required this.client, required this.baseUrl});

  /// Performs a GET request to the specified endpoint
  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('No internet connection');
    } on HttpException {
      throw NetworkException('Could not find the server');
    } on FormatException {
      throw DataParsingException('Bad response format');
    }
  }

  /// Handles HTTP response and throws appropriate exceptions
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw DataParsingException('Failed to parse response: $e');
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerException('Client error: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      throw ServerException('Server error: ${response.statusCode}');
    } else {
      throw ServerException('Unexpected error: ${response.statusCode}');
    }
  }
}
