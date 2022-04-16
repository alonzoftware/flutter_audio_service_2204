import 'package:flutter/material.dart';
import 'package:flutter_audio_service_2204/screens/app_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service 2204',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
