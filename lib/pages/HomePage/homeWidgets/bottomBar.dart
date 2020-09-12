import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
         alignment:Alignment.bottomCenter ,
          child: new BottomAppBar(
              child: Container(
              height: MediaQuery.of(context).size.height/10,
              // margin:const EdgeInsets.only() ,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(
                        FontAwesomeIcons.home,
                        color: Color(0xFFFF5E3A),
                      ),
                      onPressed: () {},
                    ),
                    new IconButton(
                      icon: Icon(
                        FontAwesomeIcons.globeAmericas,
                        size: 20,
                      ),
                      onPressed: null,
                    ),
                    new IconButton(
                      icon: Icon(
                        FontAwesomeIcons.users,
                        size: 20,
                      ),
                      onPressed: null,
                    ),
                    new IconButton(
                      icon: Icon(
                        Icons.message,
                        size: 20,
                      ),
                      onPressed: null,
                    ),
                    new IconButton(
                      icon: Icon(
                        FontAwesomeIcons.cog,
                        size: 20,
                      ),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}