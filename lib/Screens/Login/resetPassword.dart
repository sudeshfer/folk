
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                
            child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {},
          ),
                  alignment: Alignment.centerLeft,
                
              ),
          
              SizedBox(height: 12),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromRGBO(64, 75, 105, 1),fontFamily: 'Montserrat', fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                    
                child: RichText(
                  text: TextSpan(
                      text: "Reset code was sent your email. Please \n"
                            "enter ther code and create new password.",
                      style: TextStyle(color: Color.fromRGBO(64, 75, 105, 1), fontSize: 16)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                  child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey[200])),
                  labelText: 'Reset Code'),
            ),
          ),
             
             
           
                  
              Container(
                   padding: EdgeInsets.only(top: 32),
                    child: Center(
                      child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/resetpw");
                      },
                    child: Container(
                      height: 51,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Change Phone number'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
              ),
              SizedBox(
                height: 14,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
