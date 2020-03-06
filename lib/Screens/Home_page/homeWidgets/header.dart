import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  Header({Key key}) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildNotificationBtn(context),
            Text("hutta"),
            Text("hutta"),
          ]),
    );
  }

  Widget _buildNotificationBtn(BuildContext context) {
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 8.0),
          child: _buildNotificationIcon(context)),
      Positioned(bottom: 32, left: 28, child: _buildNotificationCount(context))
    ]);
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
        ),
        // borderRadius: BorderRadius.all(Radius.circular(45))
      ),
      child: Center(
        child: Container(
          height: 25.0,
          width: 25.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/ic_notification.png')),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCount(BuildContext context) {
    return Container(
        height: 17,
        width: 17,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
          gradient: LinearGradient(
            colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
          ),
          // borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        child: Center(
            child: Text(
          "1",
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w900),
        )));
  }
}
