import 'package:dio/dio.dart';

class ApiRequest {
  final String url;
  final Map<String, String> data;

  ApiRequest({
    required this.url,
    required this.data,
  });

  Dio _dio() {
    Dio dio = new Dio(BaseOptions());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "Bearer U__Pii_CeBCJFlH7EP8OaGiZ9KDF4e8rQZ15E29qhvOXIFJl9bOAUOdmJNJdC5H8";
    return dio;
  }

  void get({
    required Function(dynamic data) onSuccess,
    required Function(dynamic error) onError,
  }) {
    print("request");
    _dio().get(this.url, queryParameters: this.data).then((res) {
      print("ok");
      onSuccess(res);
    }).catchError((error) {
      onError(error);
    });
  }
}
