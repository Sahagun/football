import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/particleAPIs.dart';

import 'homepage.dart';

class RunningPage extends StatefulWidget {

  int duration;

  RunningPage(this.duration);

  @override
  _RunningPageState createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> with TickerProviderStateMixin{

  AnimationController controller;
  // Duration duration;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String buttonText = "Stop";
  bool pressed = false;
  void onButtonPress(){
    if(!pressed){
      if(controller.isAnimating){
        print("stop");
        pressed = true;
        ParticleAPI.turnoff().then(
          (response){
            var jsonBody = json.decode(response.body);

            print("Json Body");
            print(jsonBody);
            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
          }
        );

      }
      else{
        print("cont");
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
    }
    pressed = false;
  }


  AnimatedBuilder animate(){
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Text(timerString,
            style: TextStyle(
            fontSize: 40.0,
            color: Colors.black),
        );
      },
    );
  }

  @override
  void initState() {
    Duration initDur = Duration(seconds: widget.duration);

    Timer(initDur,(){
      buttonText = "Continue";
      setState(() { });
    });

    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: initDur,
    );
    // controller.forward();
    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("New Run"),
      ),
      body:
      Column(children: <Widget>[
        Expanded(child: Center(child: animate(),)),
        Center(child: ElevatedButton(onPressed: onButtonPress, child: Text(buttonText))),
      ],),
    );
  }
}