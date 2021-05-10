import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanbarcode/custom/alert.dart';
import 'package:scanbarcode/custom/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scanbarcode/custom/dialog.dart';
import 'package:scanbarcode/custom/prefs.dart';
import 'package:scanbarcode/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  initState() {
    super.initState();
  }

  SharedPref prefs = new SharedPref();
  int _status;
  String _workfrom;
  String _workto;
  int id;
  int scanID;
  var token;
  var body;
  var response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("QR Code"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: setPrefs(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      scanID != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("สถานะ: ",
                                                    style: TextStyle(
                                                        fontSize: 30)),
                                                Text("เข้างาน",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.green))
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("สถานะ: ",
                                                    style: TextStyle(
                                                        fontSize: 30)),
                                                Text("ออกงาน",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.red))
                                              ],
                                            ),
                                      Text(_workfrom ??= "-",
                                          style: TextStyle(fontSize: 25)),
                                      Text(_workto ??= "-",
                                          style: TextStyle(fontSize: 25))
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: scanID != null
                              ? GestureDetector(
                                  onTap: () async {
                                    scanQR();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.red,
                                            Colors.red,
                                          ]),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "ออกงาน",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    scanQR();
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
                                      "เข้างาน",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      CircularProgressIndicator(),
                      SizedBox()
                    ],
                  );
                }
              },
            ),
          ],
        ));
  }

  Future<bool> setPrefs() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getInt('id');
    token = preferences.getString('token');
    // CustomDialog(context: context).showLoadingDialog();
    response = await http.get('${host}welcome/getScan/$id', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Map<String, dynamic> userMap = jsonDecode(response.body);
    scanID = userMap["scanId"];
    if (scanID == null) {
      _workfrom = "-";
      _workto = "-";
      _status = userMap['scanFinished'];
    } else {
      _workfrom = userMap['scanWorkfrom'];
      _status = userMap['scanFinished'];
    }
    // CustomDialog(context: context).dismiss();
    return true;
  }

  Future<void> scanQR() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    id = preferences.getInt("id");
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    CustomDialog(context: context).showLoadingDialog();
    response =
        await http.get('${host}welcome/location/$barcodeScanRes', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (barcodeScanRes == "-1") {
      CustomDialog(context: context).dismiss();
    } else {
      if (response.body == "{}") {
        CustomDialog(context: context).dismiss();
        CustomDialog(context: context).showErrorDialog("ไม่มีสถานที่นี้");
      } else {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        Map<String, dynamic> userMap = jsonDecode(response.body);
        var locationId = userMap["locationId"];
        var locationLatitude = userMap["locationLatitude"];
        var locationLongitude = userMap["locationLongitude"];
        var R = 6371;
        var dlon = position.longitude * pi / 180 - locationLongitude * pi / 180;
        var dlat = position.latitude * pi / 180 - locationLatitude * pi / 180;


        CustomDialog(context: context).dismiss();

        var a = (pow(sin(dlat / 2), 2) +
            cos(position.latitude) *
                cos(locationLatitude) *
                (pow(sin(dlon / 2), 2)));
        var c = 2 * atan2(sqrt(a), sqrt(1 - a));
        var distance = R * c;
        if (distance > 0.025) {
          CustomDialog(context: context).dismiss();
          CustomDialog(context: context)
              .showErrorDialog("อยู่ห่างจากสถานที่เกินไป");
        } else {
          if (scanID == null) {
            body = jsonEncode({
              "latitudestart": position.latitude,
              "longitudestart": position.longitude,
              "location": locationId
            });
            response = await http.post(
              '${host}welcome/scanIn/$id',
              body: body,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );
            CustomDialog(context: context).dismiss();
            CustomDialog(context: context).showSuccessDialog("บันทึกสำเร็จ");
          } else {
            body = jsonEncode({
              "latitudeend": position.latitude,
              "longitudeend": position.longitude,
              "location": locationId
            });
            response = await http.post(
              '${host}welcome/scanOut/$id',
              body: body,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            );
            CustomDialog(context: context).dismiss();
            CustomDialog(context: context).showSuccessDialog("บันทึกสำเร็จ");
          }
        }
      }
    }
    setState(() {
      setPrefs();
    });
  }
}
