import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:scanbarcode/custom/api.dart';
import 'package:http/http.dart' as http;
import 'package:scanbarcode/custom/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanbarcode/model/category.dart';

class LeaveWork extends StatefulWidget {
  @override
  _LeaveWorkState createState() => _LeaveWorkState();
}

class _LeaveWorkState extends State<LeaveWork> {
  int isIdCategory;
  String status = "กรุณาเลือกประเภทการลา";
  var dateTime = "กรุณาเลือกวันที่จะลา";
  TextEditingController detail = new TextEditingController();
  int index = 0;
  List<CategoryList> categoryList;
  var token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: category(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnnotatedRegion<SystemUiOverlayStyle>(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 35),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      TextButton(
                                        child: Text(
                                          status,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        onPressed: () async {
                                          await showModalBottomSheet<int>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _buildItemPicker();
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime.now(),
                                                maxTime: DateTime(2200, 12, 31),
                                                onChanged: (date) {},
                                                onConfirm: (date) {
                                              setState(() {
                                                dateTime =
                                                    '${date.year}-${date.month}-${date.day}';
                                              });
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.th);
                                          },
                                          child: Text(
                                            dateTime,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 30),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                            labelText: "รายละเอียด"),
                                        controller: detail,
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (isIdCategory == null ||
                                              dateTime ==
                                                  "กรุณาเลือกวันที่จะลา") {
                                            CustomDialog(context: context)
                                                .showWarningDialog(
                                                    "กรุณากรอกข้อมูลให้ครบ");
                                          } else {
                                            isSaveOnLeave(isIdCategory,
                                                dateTime, detail.text);
                                          }
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "บันทึก",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            value: SystemUiOverlayStyle.light)
                      ],
                    ),
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
      ),
    );
  }

  Widget _buildItemPicker() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: CupertinoPicker(
              itemExtent: 70.0,
              backgroundColor: CupertinoColors.white,
              scrollController:
                  FixedExtentScrollController(initialItem: this.index),
              onSelectedItemChanged: (index) {
                setState(() {
                  //   select_name = dataZone[index].nameZone;
                  //   id = dataZone[index].id.toString();
                  status = categoryList[index].categoryName;
                  // this.index = index;
                  isIdCategory = categoryList[index].categoryId;
                  //   tables(id);
                });
              },
              children: new List<Widget>.generate(categoryList.length, (index) {
                return Center(
                  child: Text(
                    categoryList[index].categoryName,
                    style: TextStyle(fontSize: 22.0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future category() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    var response = await http.get('${host}welcome/category', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    List jsonData = json.decode(utf8.decode(response.bodyBytes));
    categoryList = jsonData.map((i) => CategoryList.fromJson(i)).toList();

  }

  Future isSaveOnLeave(int id, String date, detail) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var isIduser = preferences.getInt("id");
    var body = jsonEncode({
      "onleavedate": date,
      "onleaveemployee": isIduser,
      "onleavestatus": id,
      "onleavedetail": detail
    });
    CustomDialog(context: context).showLoadingDialog();
    var response =
        await http.post('${host}welcome/onLeave', body: body, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode >= 200 && response.statusCode < 205) {
      CustomDialog(context: context).dismiss();
      CustomDialog(context: context).showSuccessDialog("บันทึกข้อมูลสำเร็จ");
    } else {}
    setState(() {
      category();
    });
  }
}
