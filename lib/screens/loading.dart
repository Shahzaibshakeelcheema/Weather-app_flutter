import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
  );

  static const apiKey = 'b46d24d5d9b7f41e867856f16bb0d9ab';

  double? latitude;
  double? longitude;
  String cityName = '';
  double temperature = 0.0;
  String weatherDescription = '';

  @override
  void initState() {
    super.initState();
    getLocationAndFetchWeather();
  }

  Future<void> getLocationAndFetchWeather() async {
    await getLocation();
    if (latitude != null && longitude != null) {
      await getData(latitude!, longitude!);
    }
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });

        print("User's location: $latitude, $longitude");
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

  Future<void> getData(double lat, double lon) async {
    // Reverse geocoding to fetch city name
    final reverseGeoResponse = await http.get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&appid=$apiKey'));

    if (reverseGeoResponse.statusCode == 200) {
      var reverseGeoData = json.decode(reverseGeoResponse.body);
      if (reverseGeoData.isNotEmpty) {
        setState(() {
          cityName = reverseGeoData[0]['name'];
        });
      }
    } else {
      print('Reverse geocoding failed: ${reverseGeoResponse.body}');
    }

    // Weather data
    final weatherResponse = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

    try {
      if (weatherResponse.statusCode == 200) {
        var weatherData = json.decode(weatherResponse.body);

        setState(() {
          temperature = weatherData['main']['temp'];
          weatherDescription = weatherData['weather'][0]['description'];
        });

        print('Temperature: $temperature°C');
        print('Weather Description: $weatherDescription');
      } else {
        print('Failed to load weather data: ${weatherResponse.body}');
      }
    } catch (e) {
      print('Error occurred while fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.white,
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cityName.isNotEmpty ? cityName : 'Fetching City...',
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            temperature != 0.0 ? '$temperature°C' : 'Fetching Temperature...',
            style: const TextStyle(fontSize: 48, color: Colors.white),
          ),
          Text(
            weatherDescription.isNotEmpty
                ? weatherDescription
                : 'Fetching Description...',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await getLocationAndFetchWeather();
              },
              child: const Text(
                'Refresh Weather',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}