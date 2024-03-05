import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'app_url.dart';

class ApiBaseHelper {
  static final String url = AppUrl.baseUrl;
  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    // connectTimeout: 60 * 1000,
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio? addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        var customHeaders = {
          'content-type': 'application/json',
          'Accept': 'application/json',
        };
        options.headers.addAll(customHeaders);
        // Do something before request is sent
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        // Do something with response error
        return handler.next(e); //continue.
      }));
  }

  static dynamic requestInterceptor(RequestOptions options) async {
    const token = '';
    options.headers.addAll({"Content-Type": "application/json"});
    options.headers.addAll({"Accept": "application/json"});
    return options;
  }

  static Dio addInterceptorsCart(Dio dio, String token) {
    return dio
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        return requestInterceptor(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioError e, handler) {
        return handler.next(e); //continue
      }));
  }

  static Dio addInterceptorsWithOrigin(Dio dio, String token) {
    return dio
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        return requestInterceptor(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response);
      }, onError: (DioError e, handler) {
        return handler.next(e); //continue
      }));
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  Future<Response?> getHTTP(String url) async {
    try {
      Response response = await baseAPI!.get(url);
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> getHTTPWithBearerToken(String url, String token) async {
    try {
      final baseAPI = addInterceptorsCart(dio, token);
      Response response = await baseAPI.get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> postHTTPWithBearerToken(
      String url, dynamic data, String token) async {
    try {
      log('postHTTPWithBearerToken  ' + token);

      final baseAPI = addInterceptorsWithOrigin(dio, token);
      Response response = await baseAPI.post(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
        data: jsonEncode(data),
      );
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> postHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI!.post(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data),
      );

      /* Response response = await baseAPI.post(url, data: data);*/
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> putHTTP(String url, dynamic data) async {
    try {
      Response response = await baseAPI!.put(url, data: data);
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> putHTTPWithBearerToken(
      String url, dynamic data, String token) async {
    try {
      final baseAPI = addInterceptorsWithOrigin(dio, token);
      Response response = await baseAPI.put(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
        data: jsonEncode(data),
      );

      /* Response response = await baseAPI.post(url, data: data);*/
      return response;
    } on DioError catch (e) {
    }
  }

  Future<Response?> deleteHTTP(String url) async {
    try {
      Response response = await baseAPI!.delete(url);
      return response;
    } on DioError catch (e) {
    }
  }
}
