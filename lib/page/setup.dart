import 'package:flutter/material.dart';
import 'package:scanbarcode/custom/alert.dart';
import 'package:scanbarcode/custom/prefs.dart';
import 'package:scanbarcode/functions/func.dart';
import 'package:scanbarcode/main.dart';

class SetUp extends StatefulWidget {
  @override
  _SetUpState createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  SharedPref prefs = SharedPref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Set Up"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          ShowDialog("คุณต้องการออกจากระบบหรือไม่").Alert(context, () async {
            Func().logout(context);
          }, () => {});
        },
        child: Icon(Icons.logout),
      ),
    );
  }

}
