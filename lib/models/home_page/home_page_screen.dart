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

  double opacityAnimation = 0;
  double padingAnimation = 80;

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
        body: Column(
          children: <Widget>[
            _getConnectionHeader(),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            _getBody(),
          ],
        ));
  }

  Widget _getConnectionHeader() {
    return Container(
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
      ),
    );
  }

  void _setAnimation(bool isShow) {
    if (isShow) {
      setState(() {
        padingAnimation = 0;
        opacityAnimation = 1.0;
      });
    } else {
      padingAnimation = 40;
      opacityAnimation = 0;
    }
  }

  Widget _getBody() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeOutQuint,
      color: Colors.transparent,
      padding: EdgeInsets.only(top: padingAnimation),
      child: AnimatedOpacity(
          opacity: opacityAnimation,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOutQuint,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Выбор цвета подстветки салона",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Material(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
              ),
              Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/icon/car.png",
                    fit: BoxFit.fill,
                    height: 400,
                  ),
                  Positioned(
                    top: 148,
                    left: 120,
                    width: 40,
                    child: _getColorsContainer(Colors.red),
                  ),
                  Positioned(
                    top: 158,
                    left: 48,
                    width: 40,
                    child: _getColorsContainer(Colors.red),
                  ),
                  Image.asset(
                    "assets/icon/carAlpha.png",
                    fit: BoxFit.fill,
                    height: 400,
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget _getColorsContainer(Color color) {
    return Container(
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 20.0, // has the effect of softening the shadow
            spreadRadius: 6.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
    );
  }

  //********************LOGIC code */

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
      _setAnimation(false);
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
      _setAnimation(true);
    } catch (e) {
      setState(() {
        _statusLable = StatusLable(
            Colors.redAccent, "Отключено", StatusLabelIcon.disconection);
        _choices = _getVariableChousePopup(_statusLable.isLabelStatus);
      });
      _setAnimation(false);
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
