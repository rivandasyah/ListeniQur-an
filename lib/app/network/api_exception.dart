import 'package:dio/dio.dart';

/// Normalized API exception for Dio errors.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  /// Uses the API error message when available.
  factory ApiException.fromDio(DioException error) {
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ?? responseData['status'];
      if (message is String && message.isNotEmpty) {
        return ApiException(message);
      }
    }

    return ApiException(error.message ?? 'Something went wrong');
  }

  @override
  String toString() => message;
}
