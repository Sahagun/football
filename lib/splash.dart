import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detailsPage.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //
  // void goToDetailsPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => DetailsPage()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Name Goes Here!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Splash Page'),
            ElevatedButton(onPressed: null, child: Text('Start')),
          ]
        ),
      ),
    );
  }
}