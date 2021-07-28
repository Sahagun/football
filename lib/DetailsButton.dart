import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/detailsPage.dart';

import 'deviceruninfo.dart';

class DetailsButton extends StatefulWidget {

  DeviceRunInfo detail;

  DetailsButton(this.detail);

  @override
  _DetailsButtonState createState() => _DetailsButtonState();
}

class _DetailsButtonState extends State<DetailsButton> {

  void onPress(){
    // print('The button was pressed: here are the details ${widget.detail}');
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => DetailsPage(widget.detail) ));
  }

  @override
  Widget build(BuildContext context) {
    String text = "${widget.detail.uid}";
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