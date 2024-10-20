import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class HerbsDetail {
  static final logger = Logger();
  static Future<DocumentSnapshot?> fetchHerbDetails({
    required BuildContext context,
    required String id,
  }) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('Herbs').doc(id).get();
      return doc;
    } catch (e) {
      logger.w(
        'Error fetching herb details from Firestore: $e',
      );
      return null;
    }
  }
}
