import 'package:dio/dio.dart';

final class ApiClient {
  ApiClient({
    required String baseUrl,
  }) : _dio = Dio(
         BaseOptions(baseUrl: baseUrl),
       );

  final Dio _dio;

  Future<T?> get<T>(String path, {Map<String, dynamic>? query}) {
    return _dio
        .get<T>(path, queryParameters: query)
        .then((response) => response.data);
  }

  Future<T?> put<T>(String path, {Object? data}) {
    return _dio.put<T>(path, data: data).then((response) => response.data);
  }

  Future<T?> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data).then((response) => response.data);
  }

  Future<T?> delete<T>(String path, {Map<String, dynamic>? query}) {
    return _dio
        .delete<T>(path, queryParameters: query)
        .then((response) => response.data);
  }
}
