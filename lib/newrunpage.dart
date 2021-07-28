import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/particleAPIs.dart';
import 'package:football_app/runningpage.dart';
import 'package:http/http.dart';
import 'deviceruninfo.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class NewRunPage extends StatefulWidget {

  @override
  _NewRunPageState createState() => _NewRunPageState();
}

class _NewRunPageState extends State<NewRunPage> {

  int duration = 0;

  String moreDetails = "";

  String displayText(){
    if (duration == 1){
      return duration.toString() + " minute";
    }
    return duration.toString() + " minutes";
  }


  void submit(ScaffoldMessengerState messengerState) async{
    if(duration >= 1 && duration <= 180){
      print("running the test thingy");
      // testString = await ParticleAPI.turnOn();
      Response response = await ParticleAPI.turnOn(duration);
      var jsonBody = json.decode(response.body);

      print("Json Body");
      print(jsonBody);

      if(jsonBody['return_value'] != null){
        int return_value = jsonBody['return_value'];
        print("return_value");
        print(return_value);

        int durationInSeconds = duration * 60;
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => RunningPage(durationInSeconds)));
      }
      else{
        moreDetails = "No Devices Online";
        print("return_value doesn't exist");
      }

      print("should be done");
      setState(() { });
    }
    else{
      String message = "Please enter a positive whole number between 1 and 180.";
      messengerState.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Run"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child:         Column(children: <Widget>[
          Expanded(child:
          Column(children: <Widget>[
            Text(displayText()),

            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Duration in minutes',
                  labelText: 'Duration in minutes'
              ),
              onChanged: (String value){
                duration = int.tryParse(value) ?? 0;
                setState(() { });
              },
            ),

            SizedBox(height: 10),

            Text(moreDetails,style: TextStyle(
              // fontSize: 40,
              color: Colors.red,
            ),
            ),


          ]),
          ),

          ElevatedButton(onPressed: (){submit(ScaffoldMessenger.of(context));}, child: Text("Start")),
        ],),
      )
    );
  }
}