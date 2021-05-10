import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scanbarcode/main.dart';
import 'package:scanbarcode/page/launcher.dart';
import 'package:scanbarcode/page/scan_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // child: SpinKitWave(color: Colors.white, type: SpinKitWaveType.start),
            ));
  }

  void navigateUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Launcher()),
        ModalRoute.withName('/'),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
