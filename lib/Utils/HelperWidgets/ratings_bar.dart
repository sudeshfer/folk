import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RatingsBar extends StatelessWidget {
  final int val;
  final double size;
  final double padding;
  RatingsBar(this.val, {this.size = 30, this.padding = 10});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buildRatingStars(val, size, padding),
    );
  }

  List<Widget> buildRatingStars(int val, double size, double padding) {
    List<Widget> starList = [];
    for (var i = 0; i < val; i++) {
      starList.add(
        Padding(
          padding: EdgeInsets.all(padding),
          child: FaIcon(
            FontAwesomeIcons.solidStar,
            color: Color.fromRGBO(255, 94, 58, 1),
            size: size,
          ),
        ),
      );
    }
    for (var i = 0; i < (5 - val); i++) {
      starList.add(
        Padding(
          padding: EdgeInsets.all(padding),
          child: FaIcon(
            FontAwesomeIcons.solidStar,
            color: Colors.grey[300],
            size: size,
          ),
        ),
      );
    }

    return starList;
  }
}
