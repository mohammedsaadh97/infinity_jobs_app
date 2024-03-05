import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/core/widgetss/job_card_widget.dart';
import 'package:infinityjobs_app/core/widgetss/text_animation.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/services/database_helper.dart';
import 'package:lottie/lottie.dart';

class MyJobsScreeen extends StatefulWidget {
  const MyJobsScreeen({super.key});

  @override
  State<MyJobsScreeen> createState() => _MyJobsScreeenState();
}

class _MyJobsScreeenState extends State<MyJobsScreeen> {
  late Future<List<SearchQueryResponseData>> _bookmarks;
  @override
  void initState() {
    super.initState();
    _refreshBookmarks();
  }

  Future<void> _refreshBookmarks() async {
    setState(() {
      _bookmarks = DatabaseHelper.getBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Save Jobs",
        onBackPressed: () {
          Navigator.of(context).pop();
          // Add functionality for back button press
        },
        showShareButton: false,
        onSharePressed: () {
          // Add functionality for share button press
        },
      ),
      body: FutureBuilder<List<SearchQueryResponseData>>(
        future: _bookmarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return TextAnimationWidget();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bookmarks = snapshot.data!;
            return bookmarks.length != 0
              ? ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return Dismissible(
                  key: Key(bookmark.id.toString()), // Unique key for each bookmark
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Remove the item from the data source
                    setState(() {
                      bookmarks.removeAt(index);
                      DatabaseHelper.deleteBookmark(bookmark.id!);
                    });
                  },
                  child: CardWidget(bookmark),
                );
              },
            ):
                Center(child: Lottie.asset(Config().noDataFound),);
          }
        },
      ),
    );
  }

  Widget CardWidget([SearchQueryResponseData? searchqueryResponseData]){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: JobCardWidget(searchqueryResponseData: searchqueryResponseData!),
    );
  }
}
