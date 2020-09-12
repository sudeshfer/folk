import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/SearchAppBar/search_app_bar.dart';
import 'package:folk/utils/UserWidgets/user_card.dart';

class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        color1: Colors.white,
        color2: Colors.grey[200],
      ),
      bottomNavigationBar: BottomButton(),
      body: Column(
        children: <Widget>[
          HeadingContainer(),
          Flexible(
            child: ListView(
              children: <Widget>[
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
                UserCardItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardItem extends StatefulWidget {
  const UserCardItem({
    Key key,
  }) : super(key: key);

  @override
  _UserCardItemState createState() => _UserCardItemState();
}

class _UserCardItemState extends State<UserCardItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return UserCard(
      GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: FaIcon(
          FontAwesomeIcons.solidCheckCircle,
          color: (!isSelected) ? Colors.blueGrey[400] : Colors.deepOrange,
          size: 24,
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed("/profilefollowers");
        },
        child: RoundedBorderButton(
          "SEND CONFIRMATION",
          fontSize: 16,
          color1: Color.fromRGBO(255, 94, 58, 1),
          color2: Color.fromRGBO(255, 149, 0, 1),
          textColor: Colors.white,
          height: 50,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }
}

class HeadingContainer extends StatelessWidget {
  const HeadingContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Evaluations",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: 'Please select all the people who',
              children: <TextSpan>[
                TextSpan(
                  text: ' did not ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      'attend the event. Fake evaluations will lead to the account suspension.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
