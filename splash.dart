import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import './mymain.dart';

class Splash extends StatelessWidget {
  //const Splash({Key key}) : super(key: key);
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'AES ENCRYPTION SYSTEM',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 100,
        ),
        Image.asset('assets/splash.jpg'),
        SizedBox(
          height: 100,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Mymain.routeName);
          },
          child: Text('Get Started'),
        )
      ]),
    ));
  }
}
