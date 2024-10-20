// dark_pass.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DarkPass {
  static final logger = Logger();

  static Future<String?> fetchPasswordFromFirestore({
    required BuildContext context,
    int retryCount = 5,
    int delayMillis = 500,
  }) async {
    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('DarkPass')
            .doc('DarkPassAccess')
            .get();
        final password = doc['pass'] as String?;
        logger.d('Fetched password from Firestore: $password');
        return password;
      } catch (e) {
        if (attempt == retryCount) {
          logger.e(
              'Error fetching password from Firestore after $retryCount attempts: $e');
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error fetching password from Firestore. Please try again later.')),
          );
        } else {
          logger.w(
              'Attempt $attempt: Error fetching password from Firestore. Retrying in ${delayMillis * attempt}ms...');
          await Future.delayed(Duration(milliseconds: delayMillis * attempt));
        }
      }
    }
    return null;
  }
}
