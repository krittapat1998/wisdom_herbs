import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:wisdom_herbs/models/etprise_models.dart';

class AddEnterpriselistsFirebase {
  static final Logger logger = Logger();

  static Future<void> addEnterpriselistsFromFile(BuildContext context) async {
    try {
      // อ่านไฟล์ JSON
      final String response =
          await rootBundle.loadString('assets/Enterpriselists.json');
      final data = await json.decode(response) as List<dynamic>;

      // เพิ่มข้อมูลลงใน Firestore
      for (var etprise in data) {
        // ตรวจสอบว่า img เป็น array
        if (etprise['img'] is List) {
          final etpriseModel = EnterpriseLists.fromJson(etprise);

          // เพิ่มข้อมูล EnterpriseLists ลงในคอลเลกชัน EnterpriseGroup
          await FirebaseFirestore.instance
              .collection('EnterpriseGroup')
              .doc(etpriseModel.groupName) // ใช้ groupName เป็น document ID
              .set(etpriseModel.toJson());

          // เพิ่ม herbsTypes เป็นคอลเลกชันย่อย
          if (etpriseModel.herbsTypes != null) {
            for (var herbsTypeKey in etpriseModel.herbsTypes!.keys) {
              var herbsType = etpriseModel.herbsTypes![herbsTypeKey];
              if (herbsType?.herbs != null) {
                for (var herb in herbsType!.herbs!) {
                  DocumentReference herbDocRef = FirebaseFirestore.instance
                      .collection('EnterpriseGroup')
                      .doc(etpriseModel.groupName)
                      .collection(herbsTypeKey)
                      .doc(herb.herbName);

                  await herbDocRef.set(herb.toJson());
                }
              }
            }
          }
        } else {
          logger.w(
              'Skipped herb due to img not being a List: ${etprise['groupName']}');
        }
      }

      // ตรวจสอบว่า widget ยังคง mounted ก่อนแสดง SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มรายการวิสาหกิจเรียบร้อยแล้ว')),
        );
      }
    } catch (e) {
      logger.e('Error adding herbType: $e');

      // ตรวจสอบว่า widget ยังคง mounted ก่อนแสดง SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('เกิดข้อผิดพลาดในการเพิ่มรายการวิสาหกิจ')),
        );
      }
    }
  }
}
