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
      child: Padding(
        padding: const EdgeInsets.only(left:20.0,right: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNotificationBtn(context),
              _buildLogo(context),
              _buildFilterBtn(context),
            ]),
      ),
    );
  }

  Widget _buildNotificationBtn(BuildContext context) {
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 8.0),
          child: _buildNotificationIcon(context)),
      Positioned(bottom: 36, left: 32, child: _buildNotificationCount(context))
    ]);
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
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

  Widget _buildFilterBtn(BuildContext context){
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF020433), Color(0xFF020433)],
        ),
        // borderRadius: BorderRadius.all(Radius.circular(45))
      ),
      child: Center(
        child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/Filters.png')),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context){
    return Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
          );
  }

  
}
