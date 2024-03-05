import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/services/database_helper.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';

class BookmarkButton extends StatefulWidget {
  final SearchQueryResponseData searchData;

  BookmarkButton({required this.searchData});

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  Future<void> checkBookmarkStatus() async {
    bool bookmarked =
    await DatabaseHelper.isBookmarked(widget.searchData.id!);
    setState(() {
      isBookmarked = bookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (isBookmarked) {
            SnackBarHelper.showSucessSnackBar(
                context, "Already bookmarked");
            DatabaseHelper.deleteBookmark(widget.searchData.id!);
          } else {
            await DatabaseHelper.insertBookmark(widget.searchData);
            SnackBarHelper.showSucessSnackBar(
                context, "Added to bookmarks");
          }
          setState(() {
            isBookmarked = !isBookmarked;
          });
        },
        child: Container(
          height: kToolbarHeight,
          width: 100,
          child: Center(
            child: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? ColorConstant.AppBluecolor : null,
            ),
          ),
        ),
      ),
    );
  }

}
