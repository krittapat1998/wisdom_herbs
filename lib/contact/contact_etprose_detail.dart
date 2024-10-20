import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EtpriseDetail {
  static final logger = Logger();
  static Future<DocumentSnapshot?> fetchEtpriseDetails({
    required BuildContext context,
    required String id,
  }) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('EnterpriseGroup')
          .doc(id)
          .get();
      return doc;
    } catch (e) {
      logger.w(
        'Error fetching Etprise details from Firestore: $e',
      );
      return null;
    }
  }

  static fetchHerbDetails(
      {required BuildContext context, required String id}) {}
}
