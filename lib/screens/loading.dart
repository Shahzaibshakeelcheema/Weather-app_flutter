import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

Future <void> getLocation () async {

  PermissionStatus permission =  await Permission.location.request();

  if (permission == PermissionStatus.granted) {
    try{

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      print ("user's location: ${position.latitude}, ${position.longitude}");

    }
    catch(e){
      print("Error fetching the location: $e");
    }
  }
  else if (permission== PermissionStatus.denied)
{
  print("Location permission denied");
}
else if (permission== PermissionStatus.permanentlyDenied)
{
print ('Location permission permanently denied');
openAppSettings();

}}

class _LoadingState extends State<Loading> {
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
                getLocation();
              },
              child: const Text(
                'Get Location',
                style: TextStyle(color: Colors.black),
              ))),
    );
  }
}