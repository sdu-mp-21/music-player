import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiRequest {
  final String url;
  final Map<String, String> data;

  ApiRequest({
    required this.url,
    required this.data,
  });

  Dio _dio() {
    Dio dio = new Dio(BaseOptions());
    dio.options.headers['x-rapidapi-host'] = 'theaudiodb.p.rapidapi.com';
    dio.options.headers["x-rapidapi-key"] =
        "06f5b3d01bmsh25b36ed6c80e486p1d21f0jsn6da9cc97ac3c";
    return dio;
  }

  void get({
    Function(dynamic data)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    _dio().get(this.url, queryParameters: this.data).then((res) {
      print(res);
    }).catchError((error) {
      if (onError != null) onError(error);
    });
  }
}
