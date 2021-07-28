import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/FieldInfoButton.dart';
import 'package:football_app/deviceruninfo.dart';
import 'package:football_app/fieldinfo.dart';
import 'package:football_app/loginpage.dart';
import 'package:football_app/newrunpage.dart';
import 'package:football_app/runningpage.dart';

import 'DetailsButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // var detailsList = List<FieldInfo>();

  // Widget detailsButtonsTest(){
  //   if(detailsList.isEmpty){
  //     return Text('Nothing yet');
  //   }
  //   else{
  //
  //     Column buttonColumn = Column(
  //       children: [],
  //     );
  //     for(var i = 0; i < detailsList.length; i++){
  //       buttonColumn.children.add(FieldInfoButton(detailsList[i]));
  //     }
  //     return buttonColumn;
  //   }
  // }

  Future<List<FieldInfo>> getFieldDetails() async {
    print("getFieldDetails");

    List<FieldInfo> fieldList = new List<FieldInfo>();
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('GPS').once();
    if(snapshot.value != null){
      var datapoints = Map<dynamic, dynamic>.from(snapshot.value);
      for(var entry in datapoints.entries){

        int starttimestamp = int.parse(entry.key.toString());
        print("starttimestamp " + starttimestamp.toString());

        FieldInfo fieldInfo = FieldInfo(starttimestamp);


        var fieldData  =  Map<dynamic, dynamic>.from(entry.value);
        for(var device in fieldData.entries) {
          String id = device.key;

          DeviceRunInfo deviceDetail = new DeviceRunInfo(id, starttimestamp);

          var deviceData =  Map<dynamic, dynamic>.from(device.value);
          for(var timestampGPS in deviceData.entries){
            int timestamp = int.parse(timestampGPS.key);
            double latitude = double.parse(timestampGPS.value["latitude"]);
            double longitude = double.parse(timestampGPS.value["longitude"]);
            GPS gps = GPS(latitude, longitude, timestamp);
            deviceDetail.gpsCoordinates.add(gps);
          }

          Comparator<GPS> timeStampComparator = (a, b) => a.timestamp.compareTo(b.timestamp);
          deviceDetail.gpsCoordinates.sort(timeStampComparator);
          fieldInfo.deviceList.add(deviceDetail);
        }

        fieldList.add(fieldInfo);
      }
    }
    return fieldList;
  }

  Widget fieldInfoButtonColumn(){
    print("detailsButtonColumn");
      return FutureBuilder(
          future: getFieldDetails(),
          builder: (context, snapshot){
              if(snapshot.hasData){
                // make the details
                List<FieldInfo> fieldInfoList = snapshot.data;


                ListView listView = ListView.builder(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  itemCount: fieldInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FieldInfoButton(fieldInfoList[index]);
                  }
                );

                return listView;
              }
              else if (snapshot.hasError){
                return Text('An error has happened.');
              }
              return Text('Loading');
          }
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Football Tracking"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            Expanded(child: fieldInfoButtonColumn()),
            
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => NewRunPage()));
                  // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => RunningPage(5)));
                },

                child: Text("New Run",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}