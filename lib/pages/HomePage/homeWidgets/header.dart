import 'package:flutter/material.dart';
import 'package:folk/utils/notification_icon.dart';
import 'package:folk/pages/Filter_Page/FilterPage.dart';

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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildNotificationBtn(context),
              _buildLogo(context),
              _buildFilterBtn(context),
            ]),
      ),
    );
  }

  Widget _buildFilterBtn(BuildContext context) {
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
        child: GestureDetector(
          onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FilterPage()));
      },
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
        ),
      );
  }

  Widget _buildLogo(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 100,
      height: 100,
    );
  }
}
