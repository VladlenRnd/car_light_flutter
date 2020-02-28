import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() => runApp(MyApp());

final String mac = "98:D3:B1:F3:27:2A";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: currentColor,
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: pressButton,
            child: Text("Выбор цвета"),
          ),
          RaisedButton(
            onPressed: sendMessage,
            child: Text("Послыть на ардуину сигнал"),
          ),
          RaisedButton(
            onPressed: connectToDevice,
            child: Text("connect"),
          ),
          RaisedButton(
            onPressed: disconect,
            child: Text("disconect"),
          ),
        ],
      ),
    );
  }

  void disconect() {
    connection.finish();
  }

  BluetoothConnection connection;

  void connectToDevice() async {
    connection = await BluetoothConnection.toAddress(mac);
    print('Connected to the device');
  }

  void sendMessage() async {
    Uint8List data = ascii.encode("1");
    connection.output.add(data);
    //connection.input.listen(onData)
  }

  void pressButton() async {
    await showDialogColor(context);
  }

  Future showDialogColor(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
              displayThumbColor: false,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    setState(() => currentColor = color);
  }
}
