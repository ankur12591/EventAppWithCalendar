import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();
  }

  Future<Timer> splash() async {
    return Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading () {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Image.asset("assets/123.png"),
            ),
            Container(height: 480,
              padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(width: 8,),

                  Row(
                    children: <Widget>[
                      Text(
                        "Event",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "App",
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),




                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Hello!!", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 21
                          ),),
                          SizedBox(height: 4,),
                          Text("Let's explore what’s happening nearby",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                            ),)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),

                  Row(
                    children: [
                      Text("Get Started", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                      ),),
                      SizedBox(width: 5,),
                      Icon(Icons.arrow_forward, color: Colors.white,)
                    ],
                  )




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}









