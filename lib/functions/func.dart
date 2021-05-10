import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanbarcode/custom/prefs.dart';
import 'package:scanbarcode/main.dart';

class Func {
  SharedPref prefs = SharedPref();

  logout(BuildContext context) async {
    prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
      ModalRoute.withName('/'),
    );
  }
}
