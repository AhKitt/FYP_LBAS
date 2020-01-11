import 'package:flutter/material.dart';
import 'package:lbas_advertiser/loginscreen.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/lbas.jpg',
                scale: 2,
              ),
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            print('Sucess Login');
            //loadpref(context);
            Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 200,
      color: Colors.teal,
      child: LinearProgressIndicator(
        value: animation.value,
        backgroundColor: Colors.black,
        valueColor:
            new AlwaysStoppedAnimation<Color>(Color.fromRGBO(74, 210, 255, 1)),
      ),
    ));
  }
}

bool _isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}


Map<int, Color> color = {
  50: Color.fromRGBO(74, 210, 255, .1),
  100: Color.fromRGBO(74, 210, 255, .2),
  200: Color.fromRGBO(74, 210, 255, .3),
  300: Color.fromRGBO(74, 210, 255, .4),
  400: Color.fromRGBO(74, 210, 255, .5),
  500: Color.fromRGBO(74, 210, 255, .6),
  600: Color.fromRGBO(74, 210, 255, .7),
  700: Color.fromRGBO(74, 210, 255, .8),
  800: Color.fromRGBO(74, 210, 255, .9),
  900: Color.fromRGBO(74, 210, 255, 1),
};
