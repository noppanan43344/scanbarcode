import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:scanbarcode/custom/api.dart';
import 'package:http/http.dart' as http;
import 'package:scanbarcode/custom/dialog.dart';
import 'package:scanbarcode/custom/prefs.dart';
import 'package:scanbarcode/page/launcher.dart';
import 'package:scanbarcode/page/loading.dart';
import 'package:scanbarcode/page/scan_qr.dart';
import 'package:flutter/material.dart';

import 'model/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPref prefs = new SharedPref();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Center(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/QR.png"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your username'),
                      controller: _username,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your password'),
                      controller: _password,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_username.text == "" || _password.text == "") {
                          CustomDialog(context: context)
                              .showWarningDialog("กรอกข้อมูลให้ครบ");
                        } else {
                          _login(_username.text, _password.text);
                        }
                        // _login(_username.text, _password.text);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue,
                                Colors.blue,
                              ]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(String username, password) async {
    var login = Login();
    login.username = username;
    login.password = password;
    var body = jsonEncode(login);
    var response =
        await http.post('${host}authen/authenticate', body: body, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Accept': 'application/json',
    });
    Map<String, dynamic> userMap = jsonDecode(response.body);
    if (userMap["status"] == 0) {
      CustomDialog(context: context).showErrorDialog("รหัสผ่านไม่ถูกต้อง");
    } else {
      prefs.saveString("token", userMap["accessToken"].toString());
      prefs.saveInt("id", userMap["employee"]);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Launcher()),
        ModalRoute.withName('/'),
      );
    }
  }
}