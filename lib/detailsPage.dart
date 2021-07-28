import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'deviceruninfo.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class DetailsPage extends StatefulWidget {

  DeviceRunInfo detail;

  DetailsPage(this.detail);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  String date = "null";
  String startTime = "null";
  String endTime = "null";
  double duration = -1;
  double distance = -1; // feet
  double averageSpeed = -1; // feet/sec


  Widget _map(){
    List<LatLng> latlngList = [];

    for (var coord in widget.detail.gpsCoordinates){
      latlngList.add(LatLng(coord.latitude, coord.longitude));
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
      zoom: 12.0,
    );

    TileLayerOptions tile = TileLayerOptions(
      // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      //   urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      //   urlTemplate: "https://stamen-tiles.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.jpg",
        urlTemplate: "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
        // urlTemplate: "https://stamen-tiles.a.ssl.fastly.net/toner/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']
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


    FlutterMap map = FlutterMap(
      options: options,
      layers: [
        tile,
        lines,
        makers,
      ],
    );

    return Expanded(
      child: map,
    );
  }

  @override
  Widget build(BuildContext context) {

    DateTime startDatetime = new DateTime.fromMillisecondsSinceEpoch(widget.detail.starttimestamp*1000);
    DateTime endDatetime = new DateTime.fromMillisecondsSinceEpoch(widget.detail.gpsCoordinates.last.timestamp*1000);

    int durationinSeconds= widget.detail.gpsCoordinates.last.timestamp - widget.detail.starttimestamp;
    print(durationinSeconds);

    int min = durationinSeconds ~/ 60;
    int sec = durationinSeconds % 60;
    String duration = min.toString() + " min " + sec.toString() + " sec";

    print("GPS list");
    print(widget.detail.gpsCoordinates);

    date = "${startDatetime.year}-${startDatetime.month}-${startDatetime.day}";
    startTime = "${startDatetime.hour}:${startDatetime.minute}:${startDatetime.second}";
    endTime = "${endDatetime.hour}:${endDatetime.minute}:${endDatetime.second}";

    distance = widget.detail.calculateTotalDistance() * 3.2808; // Convert meter to feet
    if (distance.isFinite) {
        distance = (distance * 100).round() / 100;
    }

    averageSpeed = widget.detail.calculateSpeed() * 0.0547 / 60; // convert meter/hr to feet/secs
    if (averageSpeed.isFinite) {
      averageSpeed = (averageSpeed * 10000).round() / 10000;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(date + " " + startTime),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left:20.0, top:10.0, right:20.0, bottom: 10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Device ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Device ID: '),
                        Expanded(child: Container()),
                        Text(widget.detail.uid),
                      ],
                    ),


                    // Starting Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Date: '),
                        Expanded(child: Container()),
                        Text(date),
                      ],
                    ),


                    // Starting Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Start Time'),
                        Expanded(child: Container()),
                        Text(startTime),
                      ],
                    ),

                    // Ending Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Ending Time'),
                        Expanded(child: Container()),
                        Text(endTime),
                      ],
                    ),

                    // Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Duration'),
                        Expanded(child: Container()),
                        Text(duration),
                      ],
                    ),

                    // Distance in feet
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Distance'),
                        Expanded(child: Container()),
                        Text(distance.toString() + " ft"),
                      ],
                    ),

                    // Speed in feet per sec
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Avg Speed'),
                        Expanded(child: Container()),
                        Text(averageSpeed.toString() + " ft/sec"),
                      ],
                    ),

                  ]
              ),
            ),

            _map(),

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementSpeed,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}