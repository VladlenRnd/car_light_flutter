import 'package:flutter/cupertino.dart';

class StatusLable {
  final Color colorLable;
  final String lable;
  final StatusLabelIcon isLabelStatus;

  StatusLable(this.colorLable, this.lable, this.isLabelStatus);
}

class CustomPopupMenu {
  CustomPopupMenu(this.title, this.icon, this.variable);

  final CustomPopupMenuVariable variable;
  final String title;
  final IconData icon;
}

enum CustomPopupMenuVariable {
  removeConnect,
  reConnected,
}

enum StatusLabelIcon {
  progresIndicator,
  connection,
  disconection,
}
