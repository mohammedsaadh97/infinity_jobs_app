import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import '../network/app_url.dart';
import '../network/method.dart';
import 'base/base_repository.dart';

class SearchQueryListRepository extends BaseRepository {
  SearchQueryListRepository._internal();

  static final SearchQueryListRepository _singleInstance =
  SearchQueryListRepository._internal();

  factory SearchQueryListRepository() => _singleInstance;

  //api: search query list
  Future<SearchQueryResponse?> apiSearchQueryList(String query,String location,int sec) async {
    final body = jsonEncode({
      "query": query + " jobs",
      "location": location,
      "sec": sec
    });

    Response response = await networkProvider.call(
        method: Method.POST,
        pathUrl: AppUrl.baseUrl,
        body: body,
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    if (response.statusCode == HttpStatus.ok) {
      print("API call sucessful on search query");
      SearchQueryResponse searchQueryResponse = SearchQueryResponse.fromJson(response.data);
      return searchQueryResponse;
    } else {
      print("failed API call on search query");
      print(response.statusCode);
    }
  }
}
