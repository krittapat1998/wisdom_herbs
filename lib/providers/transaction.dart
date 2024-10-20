// import 'package:flutter/foundation.dart';
// import 'package:logger/logger.dart';
// // import 'package:wisdom_herbs/database/herbs_db.dart';
// import 'package:wisdom_herbs/models/herbs_list.dart';

// //แจ้งเตือนเมื่อมีการเปลี่ยนแปง
// class HerbsListProvider with ChangeNotifier {
//   List<HerbsLists> herbsLists = [];
//   final logger = Logger();
//   // List<HerbsLists> herbsLists = [
//   //   // HerbsLists(
//   //   //     namethai: "ชือ 1",
//   //   //     scientificName: "ชื่อย่อย 1",
//   //   //     img: "assets/images/1.jpg",
//   //   //     localName: ""),
//   // ];
//   // HerbsListProvider() {
//   //   // Listen to Firestore stream
//   //   _firestoreService.getHerbsStream().listen((herbsData) {
//   //     herbsLists = herbsData;
//   //     notifyListeners();
//   //   });
//   // }

//   // HerbsListProvider() {
//   //   _firestoreService.getHerbsStream().listen((herbsData) {
//   //     herbsLists = herbsData;
//   //     logger.d("Herbs data updated: ${herbsData.length} items");
//   //     notifyListeners();
//   //   });
//   // }
//   // HerbsListProvider() {
//   //   _firestoreService.getHerbsStream().listen((herbsData) {
//   //     herbsLists = herbsData;
//   //     notifyListeners();
//   //   });
//   // }
//   //ดึงข้อมูล
//   // List<HerbsLists> getTransection() {
//   //   return herbsLists;
//   // }
// //----------------> ฟังชั่นก์ในการเก็บข้อมูลลงเครื่อง <----------------
// //   void initData() async {
// //     var db = HerbsDB(dbName: "herbsLists.db");
// //     //ดึงข้อมูลมาแสดงผล
// //     herbsLists = await db.loadAllData();
// //     notifyListeners();
// //   }
// // }
// // ดึงข้อมูลมาแสดงผลมาก่อน
//   // void initData() async {
//   //   var db = HerbsDB(dbName: "herbsLists.db");
//   //   try {
//   //     // ดึงข้อมูลมาแสดงผล
//   //     herbsLists = await db.loadAllData();
//   //     notifyListeners();
//   //   } catch (e) {
//   //     logger.e("Failed to initialize data: $e");
//   //   }
//   // }

//   // void addTransaction(HerbsLists statement) async {
//   //   try {
//   //     await FirebaseFirestore.instance.collection('herbs').add({
//   //       'namethai': statement.namethai,
//   //       'scientificName': statement.scientificName,
//   //       'img': statement.img,
//   //       'localName': statement.localName,
//   //     });
//   //   } catch (e) {
//   //     logger.e("Failed to add transaction: $e");
//   //   }
//   // }

//   // void addTransaction(HerbsLists statement) async {
//   //   //เรียก Database เพื่อที่จะเก็บข้อมูลลงในฐานข้อมูลด้วย
//   //   var db = HerbsDB(dbName: "herbsLists.db");
//   //   try {
//   //     // บันทึกข้อมูลลงใน db ด้วย
//   //     await db.insertData(statement);
//   //     herbsLists.insert(0, statement);
//   //     // เมื่อทำการดึงข้อมูลจาก snapshot เสร็จนำมาแสดงผล
//   //     herbsLists = await db.loadAllData();
//   //     // แจ้งเตือน Consumer เพื่อให้  Consumer นำไปแสดง
//   //     notifyListeners();
//   //   } catch (e) {
//   //     logger.e("Failed to add transaction: $e");
//   //   }
//   // }
// }
