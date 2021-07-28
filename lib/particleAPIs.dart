import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ParticleAPI{

  // doesn't expire
  static String token = "cc88329cb9c3d484c52e924241756942052266d5";
  static String authKey = "";
  static String deviceID = "e00fce682f91a9b49485017b";

  static String turnOnFunctionName = "turnon";
  static String turnOffFunctionName = "turnoff";
  static String setDurationFunctionName = "setDurationAA";
  static String setPublishRateFunctionName = "setPublishRate";

  static String _baseURL = "https://api.particle.io/v1/devices/";

  static Future<String> test () async{
    var response = await http.get(
      Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
      headers: {"Accept": "application/json"}
    );

    return json.decode(response.body).toString();
  }


  static Future<Response> turnOn(int durationMinutes) async{
    _baseURL = "https://api.particle.io/v1/devices/${deviceID}/${turnOnFunctionName}";
    print(_baseURL);

    Response response = await http.post(
      Uri.encodeFull(_baseURL),
        body: {
          "arg": durationMinutes.toString()
        },
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      }
    );
    return response;
  }


  // keep duration in minutes
  static Future<Response> setDuration(int duration) async{
    _baseURL = "https://api.particle.io/v1/devices/${deviceID}/${setDurationFunctionName}";

    print(_baseURL);


    var response = await http.post(
        Uri.encodeFull(_baseURL),
        body: {
          "arg": duration.toString()
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );
    return response;
  }

  static Future<Response> turnoff() async{
    _baseURL = "https://api.particle.io/v1/devices/${deviceID}/${turnOffFunctionName}";
    print(_baseURL);
    Response response = await http.post(
        Uri.encodeFull(_baseURL),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }
    );
    return response;
  }

}