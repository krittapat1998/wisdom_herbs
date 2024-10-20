// import 'dart:io';

// import 'package:path/path.dart';
// import 'package:sembast/sembast.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sembast/sembast_io.dart';
// import 'package:wisdom_herbs/models/herbs_list.dart';
// import 'package:logger/logger.dart';

// class HerbsDB {
//   //บริการเกียวกับฐานข้อมูล

//   String? dbName; //เก็บชื่อฐานข้อมูล
//   final logger = Logger();
//   // ถ้ายังไม่ถูกสร้าง => สร้าง
//   // ถูกสร้างไว้แล้ว => เปิด
//   HerbsDB({required this.dbName});
//   //เปิด database
//   Future<Database> openDatabase() async {
//     //หาตำแหน่งที่จะเก็บข้อมูล
//     Directory appDirectory = await getApplicationDocumentsDirectory();
//     logger.e(appDirectory);
//     //ตำแหน่ง User accout dbLocation
//     String dbLocation = join(appDirectory.path, dbName);
//     // สร้าง database dbFactory
//     DatabaseFactory dbFactory = databaseFactoryIo;
//     //รวม database เข้ากับ Path
//     Database locationsDB = await dbFactory.openDatabase(dbLocation);
//     logger.e(dbLocation);
//     return locationsDB;
//   }

//   //บันทึกข้อมูล รับ statment มาจาก provider หน้า Main Form
//   //int คือ Type ข้อมูลที่ส่งกลับออกไป
//   Future<int> insertData(HerbsLists statement) async {
//     //บันทึกข้อมูลลง ฐานข้อมูล => db อะไร
//     var db = await openDatabase();
//     //และเลือก Table หรือ store จะเข้าไป
//     //รูปแบบการสร้าง Store และชื่อว่า expense หรือ  herbsLists.db มี Table หรือ sotre ด้านในชื่อว่า => expense
//     var store = intMapStoreFactory.store("expense");

//     // json
//     var keyID = store.add(db, {
//       //นิยามโครงสร้างข้อมูลที่จะเก็บ
//       "namethai": statement.namethai,
//       "scientificName": statement.scientificName,
//       "localName": statement.localName,
//       "familyName": statement.familyName,
//       "numberPictures": statement.numberPictures,
//       "img": statement.img,
//       "date": statement.date!.toIso8601String()
//     });
//     db.close();
//     //หลังจากบันทึกข้อมูลให้ส่งค่า KeyId ที่เป็น Int กลับออกไป
//     return keyID;
//   }

//   //ดึงข้อมูล---------------------------------->
//   Future<List<HerbsLists>> loadAllData() async {
//     //ดึงข้อมูลที่ฐานข้อมูล => db อะไร
//     var db = await openDatabase();
//     //และเลือก Table หรือ store จะเข้าไป
//     //รูปแบบการสร้าง Store และชื่อว่า expense หรือ  herbsLists.db มี Table หรือ sotre ด้านในชื่อว่า => expense
//     var store = intMapStoreFactory.store("expense");
//     //ค้นหาข้อมูล แล้ว return ก้อนข้อมูล snapshot ที่ไปดึงข้อมูลจาก expense
//     //List<RecordSnapshot<int, Map<String, Object?>>> snapshot
//     var snapshot = await store.find(db,

//         //เรียงลำดับใหม่
//         // ใหม่ => เก่า false มาก => น้อย
//         // เก่า => ใหม่ true น้อย => มาก
//         finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
//     logger.e(snapshot);
//     List<HerbsLists> herbsList = []; // Specify the type here

//     //การทำงานของ Snapshot
// // ปัญหาเกิดจากการเก็บข้อมูลที่มีสภาพแวดล้อมต่างกัน
// // เช่น เก็บข้อมูลใน Android หรือ iOS สภาพแวดล้อมของแต่ละ
// // Platform แตกต่างกันโดยสิ้นเชิง ส่งผลให้การจัดการข้อมูลมีความ
// // ยุ่งยากไปด้วย จึงมีแนวคิดในการสร้างประเภทข้อมูลที่สามารถทำให้
// // ข้อมูลทำงานได้ในสภาพแวดล้อมต่างกันเราเรียกส่วนนี้ว่า
// // RecordSnapshot

//     //ดึงข้อมูลจาก snapshot มาทีละ record
//     for (var record in snapshot) {
//       herbsList.add(HerbsLists(
//           namethai: record["namethai"] as String,
//           scientificName: record["scientificName"] as String,
//           localName: record["localName"] as String,
//           familyName: record["familyName"] as String,
//           img: record["img"] as String,
//           numberPictures: record["numberPictures"] as int,
//           date: DateTime.parse(record["date"] as String)));
//     }
//     return herbsList;
//   }
// }
