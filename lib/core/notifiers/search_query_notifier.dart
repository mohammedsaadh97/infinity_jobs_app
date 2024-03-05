import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/base/base_change_notifier.dart';
import 'package:infinityjobs_app/core/remote/service/search_query_repository.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';


class SearchQueryNotifier extends BaseChangeNotifier {
  bool isLoading = false;
  late SearchQueryResponse searchQueryResponse;

  List<SearchQueryResponseData> _searchqueryResponseData = [];

  List<SearchQueryResponseData> get searchqueryResponseData => _searchqueryResponseData;

  set searchqueryResponseData(List<SearchQueryResponseData> value) {
    _searchqueryResponseData = value;
    notifyListeners();
  }

//  List<CategoryListData> filteredCategoryList = [];


  SearchQueryNotifier(BuildContext context,String query,String location, int sec) {
    getSearchQueryListNotifier(context,query,location,sec);

  }

// for search query list api call
  void getSearchQueryListNotifier(context, String query, String location, int sec) async {
    await SearchQueryListRepository().apiSearchQueryList(query,location,sec).then((value) {
      searchQueryResponse = value as SearchQueryResponse;
      if (searchQueryResponse.data != null) {
        isLoading == true;
        searchqueryResponseData = searchQueryResponse.data!;
        //filteredCategoryList = List.from(categorylistdata); // Initialize filtered list
      } else {
        print("contentData API error response");
      }
    });
  }


}
