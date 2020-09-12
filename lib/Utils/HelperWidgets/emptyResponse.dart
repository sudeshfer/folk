import 'package:flutter/material.dart';

class EmptyResponse extends StatelessWidget {
  final imgurl;
  final errormsg;
  EmptyResponse(this.imgurl, this.errormsg, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imgurl,
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              errormsg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
