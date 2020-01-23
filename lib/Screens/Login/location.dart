import 'package:flutter/material.dart';

class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:  Stack(
        children: <Widget>[
          Container(
        child: new Image.asset(
              'assets/images/location_bg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),     
        //      decoration: BoxDecoration(
      //  gradient: LinearGradient(
      //    begin: Alignment.topRight,
      //    end: Alignment.bottomLeft,
      //    stops: [0.2,1.2],
      //    colors: [
     //    Color(0xFFf45d27), Color(0xFFf5851f)
      //    ],
    //hari color eka ganna be oi 
    //    ),
           //   ),
          ),
           Positioned(
            top: 50.0,
            left: (MediaQuery.of(context).size.width) / 20,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/location.jpg'),
                      fit: BoxFit.cover)),
              height: 350.0,
              width: 365.0,
            ),
          ),
           Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Container(
                        child: Text('Where are you?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                  ),
       Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 185.0),
                      child: Container(
                        child:  RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Your location service need to be turned n order for \n",
                    
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "this to work.",
                          style: TextStyle(
                              color: Colors.white,fontFamily: 'Montserrat',
                              fontSize: 14))
                    ]),
              ),
                      ),
                    ),
                  ),
          Positioned(
           top: 430,
            left: 32,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/");
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'enable location'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16,
                                       // fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                 
                 
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
