// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

const LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

const apiKey = '0c87fb8ee444ff1a89cfc638afbba244';

Future<void> getLocation() async {
  PermissionStatus permission = await Permission.location.request();

  if (permission == PermissionStatus.granted) {
    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      print("user's location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      print("Error fetching the location: $e");
    }
  } else if (permission == PermissionStatus.denied) {
    print("Location permission denied");
  } else if (permission == PermissionStatus.permanentlyDenied) {
    print('Location permission permanently denied');
    openAppSettings();
  }
}

void getData() async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appid=$apiKey'));

  if (response.statusCode == 200) {
    print('Data loaded successfully : ${response.body}');
  } else {
    print('Failed to laod data: ${response.statusCode} - ${response.body}');
  }
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 214, 214),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Loading screen',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                getData();
              },
              child: const Text(
                'Get Location',
                style: TextStyle(color: Colors.black),
              ))),
    );
  }
}