import 'package:flutter/material.dart';

class NoNotificationsMsg extends StatelessWidget {
  const NoNotificationsMsg({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/empty.png',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No Notifications yet',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
            );
  }
}