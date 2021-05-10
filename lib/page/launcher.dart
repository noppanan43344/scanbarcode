import 'package:flutter/material.dart';
import 'package:scanbarcode/custom/dialog.dart';
import 'package:scanbarcode/page/leave_work.dart';
import 'package:scanbarcode/page/scan_qr.dart';
import 'package:scanbarcode/page/setup.dart';

class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[Scan(), LeaveWork(), SetUp()];
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.qr_code),
      // ignore: deprecated_member_use
      title: Text('บันทึกเข้างาน'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sick),
      // ignore: deprecated_member_use
      title: Text('ลา'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      // ignore: deprecated_member_use
      title: Text('ตั้งค่า'),
    ),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
