import 'package:flutter/material.dart';

import 'models/home_page/home_page_screen.dart';

void main() => runApp(MyApp());

final String macAddresBluetooth = "98:D3:B1:F3:27:2A";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageScreen(),
    );
  }
}
