import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

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
              onPressed: () {},
              child: const Text(
                'Get Location',
                style: TextStyle(color: Colors.black),
              ))),
    );
  }
}
