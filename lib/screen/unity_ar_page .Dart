import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityARPage extends StatefulWidget {
  @override
  _UnityARPageState createState() => _UnityARPageState();
}

class _UnityARPageState extends State<UnityARPage> {
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: null,
          child: Container(
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            ),
          ),
        ),
      ),
    );

  }

  // // ฟังก์ชันเมื่อ Unity ถูกสร้าง
  // void onUnityCreated(UnityWidgetController controller) {
  //   _unityWidgetController = controller;
  // }

  // @override
  // void dispose() {
  //   _unityWidgetController?.dispose(); // จัดการทรัพยากรของ Unity เมื่อปิดหน้า
  //   super.dispose();
  // }
}
