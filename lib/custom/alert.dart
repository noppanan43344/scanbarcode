import 'package:flutter/material.dart';

typedef ConfirmButtonClicked();
typedef CancelButtonClicked();

class CustomAlert {
  static CustomAlert instant() {
    return CustomAlert();
  }
}

class ShowDialog {
  final content;
  ShowDialog(this.content);
  void Alert(BuildContext context, ConfirmButtonClicked confirmButtonClicked,
      CancelButtonClicked cancelButtonClicked) {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  side: BorderSide(
                    width: 4,
                    color: Colors.blue,
                  ),
                ),
                content: Text(
                  content,
                  style: TextStyle(fontSize: 25),
                ),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                      child: Text('Cancel',style: TextStyle(fontSize: 20,color: Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                        // CustomDialog().showConfirmDialog2(page, false);
                        if (cancelButtonClicked != null) cancelButtonClicked();
                      }),
                  // ignore: deprecated_member_use
                  FlatButton(
                      child: Text('Ok',style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        if (confirmButtonClicked != null)
                          confirmButtonClicked();
                      })
                  // Column(
                  //   // mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 5, vertical: 20),
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               Navigator.pop(context);
                  //               // CustomDialog().showConfirmDialog2(page, false);
                  //               if (cancelButtonClicked != null)
                  //                 cancelButtonClicked(); //
                  //             },
                  //             child: Container(
                  //               alignment: Alignment.center,
                  //               height: 45,
                  //               width: MediaQuery.of(context).size.width * 0.3,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 gradient: LinearGradient(
                  //                     begin: Alignment.topCenter,
                  //                     end: Alignment.bottomCenter,
                  //                     colors: [Colors.red, Colors.red]),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black54,
                  //                     blurRadius: 10,
                  //                     offset: Offset(6, 6), // Shadow position
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Text(
                  //                 "ยกเลิก",
                  //                 style: TextStyle(
                  //                     fontSize: 20, color: Colors.white),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 15, vertical: 20),
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               // CustomDialog().showConfirmDialog2(page, true);
                  //               if (confirmButtonClicked != null)
                  //                 confirmButtonClicked();
                  //             },
                  //             child: Container(
                  //               alignment: Alignment.center,
                  //               height: 45,
                  //               width: MediaQuery.of(context).size.width * 0.3,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 gradient: LinearGradient(
                  //                     begin: Alignment.topCenter,
                  //                     end: Alignment.bottomCenter,
                  //                     colors: [
                  //                       Colors.blue,
                  //                       Colors.blue
                  //                     ]),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black54,
                  //                     blurRadius: 10,
                  //                     offset: Offset(6, 6), // Shadow position
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: Text(
                  //                 "ยืนยัน",
                  //                 style: TextStyle(
                  //                     fontSize: 20, color: Colors.white),
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ],
                  // )
                ],
                // content: CircularProgressIndicator(),
              );
            }),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }
}
