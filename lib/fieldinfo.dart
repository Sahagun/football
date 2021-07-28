import 'package:football_app/deviceruninfo.dart';

class FieldInfo{
  int starttimestamp;
  List<DeviceRunInfo> deviceList = [];

  FieldInfo(int starttimestamp){
    this.starttimestamp = starttimestamp;
  }

  int EndTimestamp(){
    int timestamp = 0;
    for(DeviceRunInfo run in deviceList) {
      for(GPS gps in run.gpsCoordinates){
        if(gps.timestamp > timestamp){
          timestamp = gps.timestamp;
        }
      }
    }
    return timestamp;
  }
}