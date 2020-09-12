import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Color color;
  SearchBar(
    this.color, {
    Key key,
    @required this.onCancelSearch,
    @required this.onSearchQueryChanged,
  }) : super(key: key);

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  TextEditingController _searchFieldController = TextEditingController();

  clearSearchQuery() {
    _searchFieldController.clear();
    widget.onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        // color: widget.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: widget.onCancelSearch,
                ),
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: widget.color,
                    ),
                    child: TextField(
                      controller: _searchFieldController,
                      cursorColor: Colors.deepOrange,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: InkWell(
                          child: Icon(Icons.close, color: Colors.deepOrange),
                          onTap: clearSearchQuery,
                        ),
                      ),
                      onChanged: widget.onSearchQueryChanged,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
