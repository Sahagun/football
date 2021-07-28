import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_app/fieldinfo.dart';
import 'DetailsButton.dart';
import 'deviceruninfo.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class FieldInfoPage extends StatefulWidget {

  FieldInfo fieldInfo;

  FieldInfoPage(this.fieldInfo);

  @override
  _FieldInfoPageState createState() => _FieldInfoPageState();
}

class _FieldInfoPageState extends State<FieldInfoPage> {
  String date = "null";
  String startTime = "null";
  String endTime = "null";
  double duration = -1;



  Widget makeDeviceList(){
    print(widget.fieldInfo.deviceList.length);
    ListView listView = ListView.builder(
        padding: const EdgeInsets.only(left: 8, right: 8),
        itemCount: widget.fieldInfo.deviceList.length,
        itemBuilder: (BuildContext context, int index) {
          return DetailsButton(widget.fieldInfo.deviceList[index]);
        }
    );

    return Expanded(child: listView);
  }

  Widget _map(){

    TileLayerOptions tile = TileLayerOptions(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']
    );

    GPS gps = widget.fieldInfo.deviceList[0].gpsCoordinates[0];
    MapOptions options = MapOptions(
      center: LatLng(gps.latitude, gps.longitude),
      zoom: 18.0,
    );

    FlutterMap map = FlutterMap(
      options: options,
      layers: [
        tile,
        // lines,
        // makers,
      ],
    );

    for(DeviceRunInfo device in widget.fieldInfo.deviceList){

      List<LatLng> latlngList = [];

      for (gps in device.gpsCoordinates){
        latlngList.add(LatLng(gps.latitude, gps.longitude));
      }

      List<Marker> markersList = [];
      for(int i = 0; i < latlngList.length; i++ ){
        var coord = latlngList[i];
        Icon icon = Icon(Icons.adjust);
        if(i == 0){
          icon = Icon(Icons.flag, color: Colors.green, size: 35, semanticLabel: "Start");
        }
        else if(i == latlngList.length - 1){
          icon = Icon(Icons.flag, color: Colors.red,semanticLabel: "Finish");
        }

        markersList.add(
            Marker(
              width: 1000.0,
              height: 1000.0,
              point: coord,
              builder: (ctx) =>
                  Container(
                    child: icon,
                  ),
            )
        );
      }

      MapOptions options = MapOptions(
        center: latlngList[0],
        zoom: 18.0,
      );


      MarkerLayerOptions makers = MarkerLayerOptions(
        markers: markersList,
      );

      PolylineLayerOptions lines = PolylineLayerOptions(
          polylines: [Polyline(
            points: latlngList,
            isDotted: true,
            color: Color(0xFF669DF6),
            strokeWidth: 3.0,
            // borderColor: Color(0xFF1967D2),
            // borderStrokeWidth: 1,
          )]
      );

      map.layers.add(makers);
      map.layers.add(lines);

    }


    return Expanded(
      child: map,
    );
  }


  @override
  Widget build(BuildContext context) {
    int endtimestamp = widget.fieldInfo.EndTimestamp();
    int starttimestamp = widget.fieldInfo.starttimestamp;

    DateTime startDatetime = new DateTime.fromMillisecondsSinceEpoch(starttimestamp * 1000);
    DateTime endDatetime = new DateTime.fromMillisecondsSinceEpoch(endtimestamp * 1000);


    date = "${startDatetime.year}-${startDatetime.month}-${startDatetime.day}";
    startTime = "${startDatetime.hour}:${startDatetime.minute}:${startDatetime.second}";
    endTime = "${endDatetime.hour}:${endDatetime.minute}:${endDatetime.second}";

    int durationinSeconds= endtimestamp - starttimestamp;
    print(durationinSeconds);

    int min = durationinSeconds ~/ 60;
    int sec = durationinSeconds % 60;
    String duration = min.toString() + " min " + sec.toString() + " sec";


    return Scaffold(
      appBar: AppBar(
        title: Text(date + " " + startTime),
      ),
      body: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left:20.0, top:10.0, right:20.0, bottom: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Date: '),
                          Expanded(child: Container()),
                          Text(date),
                        ],
                      ),

                      // Start
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Start Time: '),
                          Expanded(child: Container()),
                          Text(startTime),
                        ],
                      ),

                      // End
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('End Time: '),
                          Expanded(child: Container()),
                          Text(endTime),
                        ],
                      ),

                      // End
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Duration: '),
                          Expanded(child: Container()),
                          Text(duration),
                        ],
                      ),


                    ]
              )
            ),
            _map(),
            makeDeviceList(),
          ],
      ),
    );
  }
}