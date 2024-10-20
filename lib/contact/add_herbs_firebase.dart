import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:wisdom_herbs/models/herb_models.dart';

class AddHerbsFirebase {
  static final Logger logger = Logger();

  static Future<void> addHerbsFromFile(BuildContext context) async {
    try {
      // อ่านไฟล์ JSON
      final String response =
          await rootBundle.loadString('assets/Herbslists.json');
      final data = await json.decode(response) as List<dynamic>;

      // เพิ่มข้อมูลลงใน Firestore
      for (var herb in data) {
        // ตรวจสอบว่า img เป็น array
        if (herb['img'] is List) {
          final herbModel = HerbsLists(
            namethai: herb['namethai'],
            scientificName: herb['scientificName'],
            img: List<String>.from(herb['img']),
            localName: herb['localName'],
            familyName: herb['familyName'],
          );

          await FirebaseFirestore.instance
              .collection('Herbs')
              .doc(herbModel.namethai) // ใช้ namethai เป็น document ID
              .set(herbModel.toJson());

          // เพิ่ม Headers และ SubHeaders
          if (herb.containsKey('paragraphs')) {
            var paragraphs = herb['paragraphs'] as Map<String, dynamic>;
            for (var paragraphKey in paragraphs.keys) {
              var headers = paragraphs[paragraphKey] as Map<String, dynamic>;
              for (var headerKey in headers.keys) {
                var header = headers[headerKey] as Map<String, dynamic>;
                DocumentReference headerDocRef = FirebaseFirestore.instance
                    .collection('Herbs')
                    .doc(herbModel.namethai)
                    .collection(paragraphKey)
                    .doc(headerKey);

                await headerDocRef.set({
                  'headerBold': header['headerBold'],
                  'headerColor': header['headerColor'],
                  'headerText': header['headerText'],
                });

                if (header.containsKey('subHeaders')) {
                  var subHeaders = header['subHeaders'] as Map<String, dynamic>;
                  for (var subHeaderKey in subHeaders.keys) {
                    var subHeader =
                        subHeaders[subHeaderKey] as Map<String, dynamic>;
                    DocumentReference subHeaderDocRef =
                        headerDocRef.collection('subHeaders').doc(subHeaderKey);

                    await subHeaderDocRef.set({
                      'subHeadBold': subHeader['subHeadBold'],
                      'subHeadColor': subHeader['subHeadColor'],
                      'subHeadText': subHeader['subHeadText'],
                    });
                  }
                }
              }
            }
          }
        } else {
          logger.w(
              'Skipped herb due to img not being a List: ${herb['namethai']}');
        }
      }

      // ตรวจสอบว่า widget ยังคง mounted ก่อนแสดง SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มรายการสมุนไพรเรียบร้อยแล้ว')),
        );
      }
    } catch (e) {
      logger.e('Error adding herbs: $e');

      // ตรวจสอบว่า widget ยังคง mounted ก่อนแสดง SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('เกิดข้อผิดพลาดในการเพิ่มรายการสมุนไพร')),
        );
      }
    }
  }
}
