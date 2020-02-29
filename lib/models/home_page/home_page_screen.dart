import 'dart:convert';
import 'dart:typed_data';

import 'package:car_light_flutter/main.dart';
import 'package:car_light_flutter/tools/label_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  List<CustomPopupMenu> _choices;

  BluetoothConnection connection;

  StatusLable _statusLable = StatusLable(
      Colors.yellowAccent, "Подключение", StatusLabelIcon.progresIndicator);

  @override
  void initState() {
    super.initState();
    _connectToDevice();
    _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          _choices != null
              ? PopupMenuButton<CustomPopupMenu>(
                  color: Colors.white,
                  offset: Offset(0, 30),
                  onSelected: _onSelectedPopupMenu,
                  itemBuilder: (BuildContext context) {
                    return _choices.map((CustomPopupMenu choice) {
                      return PopupMenuItem<CustomPopupMenu>(
                          value: choice,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(choice.title),
                                Icon(
                                  choice.icon,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ));
                    }).toList();
                  },
                )
              : Container(),
        ],
        backgroundColor: Color(0xFF364fa7),
        title: Text("Главная"),
      ),
      backgroundColor: Color(0xFF4f69c6),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFF5a6fba),
          width: double.infinity,
          height: 50,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  "Статус подключения:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _statusLable.lable,
                  style: TextStyle(
                    color: _statusLable.colorLable,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  child: _getIconOnStatus(_statusLable.isLabelStatus),
                ),
              ),
            ],
          )),
    );
  }

  Widget _getIconOnStatus(StatusLabelIcon status) {
    switch (status) {
      case StatusLabelIcon.connection:
        return Container(
          height: 20,
          width: 20,
          child: Icon(
            Icons.bluetooth_connected,
            color: Colors.greenAccent,
          ),
        );
        break;
      case StatusLabelIcon.disconection:
        return Container(
          height: 20,
          width: 20,
          child: Icon(
            Icons.bluetooth_disabled,
            color: Colors.redAccent,
          ),
        );
        break;
      case StatusLabelIcon.progresIndicator:
        return CircularProgressIndicator();
        break;
      default:
        return Container(
          height: 20,
          width: 20,
        );
    }
  }

  List<CustomPopupMenu> _getVariableChousePopup(StatusLabelIcon status) {
    List<CustomPopupMenu> resultList = List<CustomPopupMenu>();

    switch (status) {
      case StatusLabelIcon.progresIndicator:
        return null;
        break;
      case StatusLabelIcon.connection:
        resultList.add(CustomPopupMenu('Отключиться', Icons.bluetooth_disabled,
            CustomPopupMenuVariable.removeConnect));
        break;
      case StatusLabelIcon.disconection:
        resultList.add(CustomPopupMenu('Повторить', Icons.bluetooth_searching,
            CustomPopupMenuVariable.reConnected));
        break;
      default:
        return null;
    }

    return resultList;
  }

  void _disconect() {
    try {
      connection.finish();
      setState(() {
        _statusLable = StatusLable(
            Colors.redAccent, "Отключено", StatusLabelIcon.disconection);
        _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
      });
    } catch (e) {}
  }

  void _connectToDevice() async {
    try {
      connection = await BluetoothConnection.toAddress(macAddresBluetooth);
      print('Connected to the device');
      setState(() {
        _statusLable = StatusLable(
            Colors.greenAccent, "Подключено", StatusLabelIcon.connection);
        _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
      });
    } catch (e) {
      setState(() {
        _statusLable = StatusLable(
            Colors.redAccent, "Отключено", StatusLabelIcon.disconection);
        _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
      });
    }
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

  void _onSelectedPopupMenu(CustomPopupMenu value) {
    switch (value.variable) {
      case CustomPopupMenuVariable.removeConnect:
        _disconect();
        break;
      case CustomPopupMenuVariable.reConnected:
        setState(() {
          _statusLable = StatusLable(Colors.yellowAccent, "Подключение",
              StatusLabelIcon.progresIndicator);
          _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
        });
        _connectToDevice();
        break;
    }
  }
}
