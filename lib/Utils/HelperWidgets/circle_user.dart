import 'package:flutter/material.dart';

class AlignedCircleUser extends StatelessWidget {
  final Alignment alignment;
  final CircleUser circleUser;
  AlignedCircleUser(
    this.alignment,
    this.circleUser,
  );
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: circleUser,
    );
  }
}

class CircleUser extends StatelessWidget {
  final String url;
  final int val;
  final double size;
  final double fontSize;
  final bool withBorder;
  final double borderThickness;
  final Color borderColor;
  final Color color;
  const CircleUser({
    this.url = "",
    this.val = 0,
    this.color = Colors.white,
    this.size = 30,
    this.withBorder = false,
    this.fontSize,
    this.borderThickness = 2,
    this.borderColor = Colors.deepOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .5),
        border: Border.all(
          width: (withBorder) ? borderThickness : 0.0,
          color: (withBorder) ? borderColor : Colors.transparent,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipOval(
          child: (url != "")
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Color.fromRGBO(48, 59, 64, 1),
                  child: (val == 0)
                      ? Container(
                          color: Colors.deepOrange,
                        )
                      : Center(
                          child: Text(
                          "+$val",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                        )),
                ),
        ),
      ),
    );
  }
}
