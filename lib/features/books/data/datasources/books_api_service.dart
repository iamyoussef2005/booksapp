import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/api_exception.dart';
import '../models/book_model.dart';

class BooksApiService {
  BooksApiService({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? ApiConstants.baseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                sendTimeout: ApiConstants.sendTimeout,
                responseType: ResponseType.json,
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: false,
      ),
    );
  }

  final Dio _dio;

  Future<List<BookModel>> fetchBooks({
    int page = 1,
    int limit = 20,
    String? category,
    bool? featuredOnly,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.booksPath,
        queryParameters: {
          'page': page,
          'limit': limit,
          'category': category?.isNotEmpty == true ? category : null,
          'featured': featuredOnly,
        },
      );

      return _parseBooksResponse(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ApiException('Unexpected error while fetching books.');
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await _dio.get<dynamic>(ApiConstants.categoriesPath);
      final categories = _extractList(response.data, fallbackKeys: ['data', 'categories']);

      return categories.map((item) => item.toString()).toList();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ApiException('Unexpected error while fetching categories.');
    }
  }

  Future<List<BookModel>> searchBooks({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    double? minRating,
  }) async {
    if (query.trim().isEmpty) {
      return const <BookModel>[];
    }

    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.searchPath,
        queryParameters: {
          'query': query,
          'page': page,
          'limit': limit,
          'category': category?.isNotEmpty == true ? category : null,
          'minRating': minRating,
        },
      );

      return _parseBooksResponse(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (_) {
      throw const ApiException('Unexpected error while searching books.');
    }
  }

  List<BookModel> _parseBooksResponse(dynamic data) {
    final items = _extractList(data, fallbackKeys: ['data', 'results', 'books']);

    return items
        .whereType<Map<String, dynamic>>()
        .map(BookModel.fromJson)
        .toList();
  }

  List<dynamic> _extractList(dynamic data, {required List<String> fallbackKeys}) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      for (final key in fallbackKeys) {
        final value = data[key];
        if (value is List) {
          return value;
        }
      }
    }

    throw const ApiException('Invalid response format from server.');
  }

  ApiException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException('Connection timed out. Please try again.');
      case DioExceptionType.sendTimeout:
        return const ApiException('Request timed out while sending data.');
      case DioExceptionType.receiveTimeout:
        return const ApiException('Server took too long to respond.');
      case DioExceptionType.connectionError:
        return const ApiException('No internet connection or server unreachable.');
      case DioExceptionType.badCertificate:
        return const ApiException('Could not verify the server certificate.');
      case DioExceptionType.cancel:
        return const ApiException('Request was cancelled.');
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode, error.response?.data);
      case DioExceptionType.unknown:
        return ApiException(error.message ?? 'Unexpected network error occurred.');
    }
  }

  ApiException _mapStatusCode(int? statusCode, dynamic data) {
    final serverMessage = _extractServerMessage(data);

    switch (statusCode) {
      case 400:
        return ApiException(serverMessage ?? 'Bad request sent to the server.', statusCode: statusCode);
      case 401:
        return ApiException(serverMessage ?? 'You are not authorized to perform this action.', statusCode: statusCode);
      case 403:
        return ApiException(serverMessage ?? 'Access to this resource is forbidden.', statusCode: statusCode);
      case 404:
        return ApiException(serverMessage ?? 'Requested resource was not found.', statusCode: statusCode);
      case 500:
      case 502:
      case 503:
      case 504:
        return ApiException(serverMessage ?? 'Server error occurred. Please try again later.', statusCode: statusCode);
      default:
        return ApiException(serverMessage ?? 'Request failed. Please try again.', statusCode: statusCode);
    }
  }

  String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'] ?? data['detail'];
      if (message != null) {
        return message.toString();
      }
    }

    return null;
  }
}
