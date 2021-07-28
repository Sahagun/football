import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/detailsPage.dart';
import 'package:football_app/fieldinfo.dart';
import 'package:football_app/fieldinfoPage.dart';

import 'deviceruninfo.dart';

class FieldInfoButton extends StatefulWidget {

  FieldInfo fieldInfo;

  FieldInfoButton(this.fieldInfo);

  @override
  _FieldInfoButtonState createState() => _FieldInfoButtonState();
}

class _FieldInfoButtonState extends State<FieldInfoButton> {

  void onPress(){
    // print('The button was pressed: here are the details ${widget.detail}');
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => FieldInfoPage(widget.fieldInfo) ));
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(widget.fieldInfo.starttimestamp*1000);
    String text = "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}";
    return ElevatedButton(
        onPressed: onPress,
        child: Text(text,
          style: TextStyle(
            fontSize: 20.0,
            // color: Colors.black
          ),
        )
    );
  }
}