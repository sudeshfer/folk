import 'package:flutter/material.dart';
import 'package:folk/pages/NotificationPage/Notifictionpage.dart';
import 'package:folk/utils/notification_icon.dart';

import 'my_painter.dart';
import 'search_bar.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final Color color1;
  final Color color2;
  final bool blackSearchIcon;
  final Color searchIconBackgroundColor;
  SearchAppBar({
    this.leading = const Icon(
      Icons.arrow_back,
      color: Colors.black,
    ),
    this.color1,
    this.color2,
    this.blackSearchIcon = false,
    this.searchIconBackgroundColor = Colors.white,
  });
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  AnimationController _controller;
  Animation _animation;
  bool isInSearchMode = false;

  @override
  initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        isInSearchMode = true;
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
  }

  cancelSearch() {
    setState(() {
      isInSearchMode = false;
    });

    onSearchQueryChange('');
    _controller.reverse();
  }

  onSearchQueryChange(String query) {
    print('search $query');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      AppBar(
        backgroundColor: widget.color1,
        elevation: 0,
        // title: Text(
        //   "Flutter App",
        //   style: TextStyle(
        //     color: Colors.black,
        //   ),
        // ),
        // leading: widget.leading,
        actions: <Widget>[
         GestureDetector(
            onTap: () {
              print("hutto");
            },
            child: Container(
              // padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(left:20,right: 10),
              // height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (widget.blackSearchIcon)
                    ? Colors.black
                    : widget.searchIconBackgroundColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: (widget.blackSearchIcon) ? Colors.red : Colors.black,
                ),
              ),
            ),
            onTapUp: onSearchTapUp,
          )
        ],
      ),
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: MyPainter(
              widget.color2,
              containerHeight: widget.preferredSize.height,
              center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
              radius: _animation.value * screenWidth,
              context: context,
            ),
          );
        },
      ),
      isInSearchMode
          ? (SearchBar(
              widget.color1,
              onCancelSearch: cancelSearch,
              onSearchQueryChanged: onSearchQueryChange,
            ))
          : (Container()),
        isInSearchMode?Container() : GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed('/notifications');4
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NotificationPage()));
      },
                  child: Container(
               padding: const EdgeInsets.only(left:18.0,bottom: 5),
               child: Align(
                 alignment: Alignment.bottomLeft,
                 child: buildNotificationBtn(context)),
             ),
        ),
    ]);
  }
}
