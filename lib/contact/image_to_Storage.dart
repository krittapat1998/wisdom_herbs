import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ImageToStorage {
  static final Logger logger = Logger();

  static Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> downloadUrls = [];

    for (var image in images) {
      File file = File(image.path);
      logger.d('Uploading image with path: ${file.path}'); // Log the image path
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref =
          FirebaseStorage.instance.ref().child('HerbsPicture').child(fileName);

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }
}
