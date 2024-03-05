import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../main.dart';

import 'app_url.dart';
import 'method.dart';

class NetworkProvider {
  var log;

  // singleton boilerplate
  NetworkProvider._internal();

  static final NetworkProvider _singleInstance = NetworkProvider._internal();

  factory NetworkProvider() => _singleInstance;


  Duration timeout = Duration(minutes: 2);


  static BaseOptions opts = BaseOptions(
    responseType: ResponseType.json,
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
    sendTimeout: Duration(seconds: 60),
  );

  static Dio? dio = Dio(opts);
  static Dio? client = addInterceptors(dio!);

  static Dio? addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // var customHeaders = {
            //   'content-type': 'application/json',
            //   'Accept': 'application/json',
            // };
            // var customHeaders = {
            //   'content-type': 'application/octet-stream',
            // };
            // options.headers.addAll(customHeaders);
            return handler.next(options); //continue
          },
          onResponse: (response, handler) {
            return handler.next(response); // continue
          },
          onError: (DioError e, handler) async {
            if (e.message == "XMLHttpRequest error.") {
              return;
            }
            return handler.next(e); //continue.
          },

            // onError: (DioError e, handler) async {
            //   if (e.message == "XMLHttpRequest error.") {
            //     return;
            //   }else if(e.response!.statusCode == 401){
            //     print("status code 401");
            //     var isUserLoggedIn;
            //     await SharedPreferencesMobileWeb.instance
            //         .getAccessToken(SharedPreferencesMobileWeb.AuthToken)
            //         .then((value) {
            //       isUserLoggedIn = value;
            //     });
            //     if(isUserLoggedIn != ""){
            //       await apiRefreshTokenAPI();
            //    }else{
            //       await deviceAuthentication();
            //     }
            //
            //     Future.delayed(const Duration(milliseconds: 3000), () {
            //       //_retry(e.requestOptions);
            //     });
            //
            //     return;
            //   }
            //   return handler.next(e);
            //
            //   //continue.
            // },
        ),
      );
  }

 static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio!.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  static commonErrorResponseHandling(DioError dioError) async {
    var urlPath = dioError.requestOptions.path;
    Response? response = dioError.response;
    print(response);
    print ("commonErrorResponseHandling API response status code:==>"+response!.statusCode.toString());
    if (response!.statusCode == HttpStatus.unauthorized) {
      //deviceAuthentication();
      return response;
    } else if (response.statusCode == HttpStatus.forbidden) {
      return response;
    } else if (response.statusCode == HttpStatus.notFound) {
      return response;
    } else if (response.statusCode == HttpStatus.unprocessableEntity) {
      return response;
    } else if (response.statusCode == HttpStatus.badRequest) {
      return response;
    } else {
      return response;
    }
  }

  Future call(
      {String? pathUrl,
      var queryParam,
      headers,
      Encoding? encoding,
      Method? method,
      body,
      bool? download,ResponseType? responseType}) async {
    var responseData;

    var url;
    if (queryParam == null) {
      url = AppUrl.baseUrl!;
    } else {
      url = Uri.encodeFull(AppUrl.baseUrl+queryParam);
    }
    print("API URL :==>$url");
    print("API body :==>$body");

    switch (method) {
      case Method.GET:
        try {
          responseData = await client!
              .get(url,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.POST:
        try {
          responseData = await client!
              .post(url,
                  data: body,

                  options: Options(
                    headers: headers,

                    // responseType: responseType
                  ))
              .timeout(timeout);
          print('in post');
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.PUT:
        try {
          responseData = await client!
              .put(url,
                  data: body,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      case Method.DELETE:
        try {
          responseData = await client!
              .delete(url,
                  data: body,
                  options: Options(
                    headers: headers,
                  ))
              .timeout(timeout);
        } on DioError catch (dioError) {
          return commonErrorResponseHandling(dioError);
        }
        break;
      default:
        break;
    }
    print("API response  :==>$responseData");
    Response response = responseData;
    print("API response status code :==>"+response.statusCode.toString());
    return responseData;
  }

 static Map<String, String> buildDefaultHeaderWithToken(String token) {
    final headerContentTypeAndAccept = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    };
    Map<String, String> header = headerContentTypeAndAccept;
    header.remove(HttpHeaders.authorizationHeader);
    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => getFormattedToken(token));
    return header;
  }

  static String getFormattedToken(String token) {
    return 'Bearer $token';
  }

}
