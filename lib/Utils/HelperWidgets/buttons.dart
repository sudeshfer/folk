import 'package:flutter/material.dart';

class RoundedBorderButton extends StatelessWidget {
  final String name;
  final Color color1;
  final Color color2;
  final Color textColor;
  final double height;
  final double width;
  final double fontSize;
  final Color shadowColor;
  RoundedBorderButton(
    this.name, {
    this.color1 = Colors.grey,
    this.color2 = Colors.grey,
    this.textColor = Colors.black,
    this.height = 35,
    this.width,
    this.fontSize = 12,
    this.shadowColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: (shadowColor == null) ? Colors.grey[300] : shadowColor,
            offset: new Offset(5.0, 6.0),
            spreadRadius: 2.0,
            blurRadius: 12.0,
          )
        ],
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
