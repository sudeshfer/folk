import 'package:flutter/material.dart';
import 'package:folk/pages/AddPost.dart';
import 'package:folk/pages/ConversionPage.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:folk/pages/Profile_Page/Profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/evez_people_explorer.dart';
import 'package:folk/pages/Messaging/profile_inbox_screen.dart';
import 'package:provider/provider.dart';
import 'package:folk/pages/Create/create.dart';

class BottomBar extends StatefulWidget {
  final String selected;
  BottomBar({this.selected = 'home'});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / 10,
        // margin:const EdgeInsets.only() ,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new IconButton(
              icon: Icon(
                FontAwesomeIcons.home,
                color: (widget.selected == 'home')
                    ? Color(0xFFFF5E3A)
                    : Colors.grey[500],
              ),
              onPressed: () {
                if(widget.selected != 'home'){
                   Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home()));
                }
                
              },
            ),
            new IconButton(
              icon: Icon(
                FontAwesomeIcons.globeAmericas,
                size: 20,
                color: (widget.selected == 'evezpeopleexplorer')
                    ? Color(0xFFFF5E3A)
                    : Colors.grey[500],
              ),
              onPressed: () {
                if(widget.selected != 'evezpeopleexplorer'){
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EvezPeopleExplorerPage()));

                }
                
              },
            ),
            SizedBox(width: 20),
            // new IconButton(
            //   icon: Icon(
            //     FontAwesomeIcons.users,
            //     size: 20,
            //     color: (widget.selected == 'profilesettings3')
            //         ? Color(0xFFFF5E3A)
            //         : Colors.grey[500],
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pushNamed("/profilesettings3");
            //   },
            // ),
            new IconButton(
              icon: Icon(
                Icons.message,
                color: (widget.selected == 'message')
                    ? Color(0xFFFF5E3A)
                    : Colors.grey[500],
                size: 20,
              ),
              onPressed: () {
                if(widget.selected != 'message'){
                  
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileInboxScreen()));
                }
                
              },
            ),
            new IconButton(
              icon: Icon(
                FontAwesomeIcons.solidUser,
                size: 20,
                color: (widget.selected == 'profile')
                    ? Color(0xFFFF5E3A)
                    : Colors.grey[500],
              ),
              onPressed: () {
                if(widget.selected != 'profile'){
                   Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile()));
                }
               
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarWithFloatingBtn extends StatelessWidget {
  final String selected;
  const BottomBarWithFloatingBtn({
    this.selected = 'home',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildCircleBorder(context),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomStack(context))
      ],
    );
  }

  Widget _buildBottomStack(BuildContext context) {
    return Stack(children: <Widget>[
      _buildBottomBar(context),
      Positioned(child: _buildPostImg(context)),
      Positioned(child: _buildPostBtnIcon(context))
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    return new Container(
      height: 120.0,
      alignment: Alignment.center,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: BottomBar(
          selected: selected,
        ),
      ),
    );
  }

  Widget _buildPostImg(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostType()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/PostImg.png')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostBtnIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostType()));
        print('hello');
      },
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        // color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleBorder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 90.0,
      width: 90.0,
      decoration: BoxDecoration(
        image: new DecorationImage(
            fit: BoxFit.fill,
            image: new AssetImage('assets/images/Circle_Border.png')),
      ),
    );
  }
}
