import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String val;
  final Color valColor;
  final Color backbroundColor;
  final Color borderColor;
  final double fontSize;
  Tag(this.val, this.valColor, this.backbroundColor, this.borderColor,
      {this.fontSize = 10});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        color: backbroundColor,
      ),
      child: Center(
        child: Text(
          val,
          style: TextStyle(
            color: valColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
