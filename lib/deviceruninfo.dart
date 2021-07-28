import 'dart:math';

class DeviceRunInfo{
  String uid;
  List<GPS> gpsCoordinates = <GPS>[];

  // Convert to datetime once we know the format of the timestamp of the hardware
  int starttimestamp;

  DeviceRunInfo(String uid, int starttimestamp){
    this.uid = uid;
    this.starttimestamp = starttimestamp;
  }

  // calculated in meters per hour
  double calculateSpeed(){
    double distance = calculateTotalDistance();
    int seconds = gpsCoordinates.last.timestamp - starttimestamp;
    double hours = 1.0 * seconds / 60.0 / 60.0;

    return distance/hours;
  }

  // calculated in meters
  double calculateTotalDistance(){
    double totalGPSDistance = 0;
    if (gpsCoordinates.length >= 2){
      for(int i = 0; i < gpsCoordinates.length-1; i++){
        var temp = calculateDistance(gpsCoordinates[i], gpsCoordinates[i+1]);
        totalGPSDistance +=  temp;
      }
    }

    return totalGPSDistance;
  }

  // Returns answer in meters
  double calculateDistance(GPS coord1, GPS coord2){
    // Radius of the Earth in meters
    double r = 6371000.0;

    double phi_1 = coord1.latitude * pi / 180;
    double phi_2 = coord2.latitude * pi / 180;

    double delta_phi = (coord2.latitude - coord1.latitude) * pi / 180;
    double delta_lambda = (coord2.longitude - coord1.longitude) * pi / 180;

    double a = pow(sin(delta_phi / 2.0), 2) + cos(phi_1) * cos(phi_2) * pow(sin(delta_lambda / 2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));

    return r * c ;
  }

  @override
  String toString(){
    return "to string function";
    //return date.toString() + ': avgSpeed = ' + avgSpeed.toString() + ', distance = ' + distance.toString();
  }
}

class GPS implements Comparable<GPS>{
  double latitude;
  double longitude;
  // Convert to datetime once we know the format of the timestamp of the hardware
  int timestamp;

  GPS(double latitude, double longitude, int timestamp){
    this.latitude = latitude;
    this.longitude = longitude;
    this.timestamp = timestamp;
  }

  @override
  int compareTo(GPS other){
    return timestamp - other.timestamp;
  }

  @override
  String toString() {
    return "TS: ${timestamp.toString()}; Lat: ${latitude.toString()}, Lng: ${longitude.toString()}";
  }
}