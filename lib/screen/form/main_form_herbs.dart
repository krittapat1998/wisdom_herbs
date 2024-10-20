import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:wisdom_herbs/contact/contact_head_form_manager.dart';
import 'package:wisdom_herbs/contact/image_to_Storage.dart';
import 'package:wisdom_herbs/models/header_paragraph.dart';
import 'package:wisdom_herbs/models/herb_models.dart';
import 'package:wisdom_herbs/screen/page_herbs_list.dart';

class FormHerbs extends StatefulWidget {
  const FormHerbs({super.key});

  @override
  _FormHerbsState createState() => _FormHerbsState();
}

class _FormHerbsState extends State<FormHerbs> {
  final GlobalKey<FormState> _mainFormKey = GlobalKey<FormState>();
  HerbsLists myHerbs = HerbsLists();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  bool _isLoading = false;
  bool _isPickingImages = false;

  final CollectionReference _herbsListsCollection =
      FirebaseFirestore.instance.collection("Herbs");

  var logger = Logger();
  late ContactFormHeadManager _contactHeadFormManager;

  @override
  void initState() {
    super.initState();
    _contactHeadFormManager = ContactFormHeadManager(_updateUI);
  }

  void _updateUI() {
    setState(() {});
  }

  Future<void> _pickImage() async {
    if (_images != null && _images!.isNotEmpty) return;
    if (_isPickingImages) return;

    setState(() {
      _isPickingImages = true;
    });

    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          _images = selectedImages;
        });
      }
    } catch (e) {
      logger.e("Error picking images: $e");
    } finally {
      setState(() {
        _isPickingImages = false;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_images != null && _images!.isNotEmpty) {
      List<String> downloadUrls = await ImageToStorage.uploadImages(_images!);
      myHerbs.img = downloadUrls;
    } else {
      myHerbs.img = [
        'https://firebasestorage.googleapis.com/v0/b/winsdom-herbs.appspot.com/o/System_image%2Ficon_image.jpg?alt=media&token=78b614c8-ae72-43bd-8d9f-6aa8f3db11e2'
      ];
    }
  }

  Future<void> _saveHeadersWithSubheaders(DocumentReference docRef,
      String collectionName, List<Header> headers) async {
    logger.d("Entering _saveHeadersWithSubheaders");
    for (var i = 0; i < headers.length; i++) {
      var header = headers[i];
      var headerId = 'Header${i + 1}';
      logger.d("Header data: ${header.toJson()}");

      DocumentReference headerRef =
          docRef.collection(collectionName).doc(headerId);

      // Save the header data
      await headerRef.set(header.toJson());
      logger.d("Header saved successfully: ${header.headerText}");

      // Check if header has sub-headers
      if (header.subHeaders != null && header.subHeaders!.isNotEmpty) {
        logger.d("Header has subHeaders: ${header.subHeaders!.length}");
        for (var j = 0; j < header.subHeaders!.length; j++) {
          var subHeader = header.subHeaders![j];
          var subHeaderId = 'subHeader${j + 1}';
          logger.d("Saving subHeader: ${subHeader.toJson()}");
          // Add each sub-header to the "subHeaders" sub-collection
          await headerRef
              .collection("subHeaders")
              .doc(subHeaderId)
              .set(subHeader.toJson());
          logger
              .d("Subheader saved successfully under ${subHeader.subHeadText}");
        }
      } else {
        logger.d("No subheaders for header: ${header.headerText}");
      }
    }
  }

  Future<void> _saveAllParagraphs(DocumentReference docRef) async {
    logger.d("Entering _saveAllParagraphs");
    var paragraph1 = _contactHeadFormManager.getFormList(1);
    var paragraph2 = _contactHeadFormManager.getFormList(2);
    var paragraph3 = _contactHeadFormManager.getFormList(3);
    var paragraph4 = _contactHeadFormManager.getFormList(4);

    if (paragraph1.isNotEmpty) {
      logger.d("Saving Paragraph1 headers");
      await _saveHeadersWithSubheaders(docRef, 'Paragraph1', paragraph1);
    }
    if (paragraph2.isNotEmpty) {
      logger.d("Saving Paragraph2 headers");
      await _saveHeadersWithSubheaders(docRef, 'Paragraph2', paragraph2);
    }
    if (paragraph3.isNotEmpty) {
      logger.d("Saving Paragraph3 headers");
      await _saveHeadersWithSubheaders(docRef, 'Paragraph3', paragraph3);
    }
    if (paragraph4.isNotEmpty) {
      logger.d("Saving Paragraph4 headers");
      await _saveHeadersWithSubheaders(docRef, 'Paragraph4', paragraph4);
    }
  }

  void _saveForm() async {
    if (_mainFormKey.currentState!.validate() &&
        _contactHeadFormManager.validateAllForms()) {
      _mainFormKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      _showLoadingDialog();

      try {
        await _uploadImages();

        // Get a DocumentReference for the new document
        DocumentReference docRef = _herbsListsCollection.doc();

        // Set the document data
        await docRef.set(myHerbs.toJson());

        // Save all paragraphs
        logger.d("Calling _saveAllParagraphs");
        await _saveAllParagraphs(docRef);

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PageHerbsList()),
        );
      } catch (e) {
        logger.e("Error saving form: $e");
      } finally {
        _hideLoadingDialog();
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")));
      logger.e("Form validation failed");
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("กำลังอัปโหลดข้อมูล..."),
          ],
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("จัดการข้อมูลสมุนไพร"),
                backgroundColor: Colors.green,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageHerbsList(),
                      ),
                    );
                  },
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _mainFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "ชื่อไทย:",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.left,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color.fromARGB(255, 219, 218, 218),
                                focusColor: Colors.blue,
                                hintText: 'ระบุชื่อไทย',
                              ),
                              validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อไทย",
                              ).call,
                              onSaved: (String? namethai) {
                                myHerbs.namethai = namethai;
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "ชื่อวิทยาศาสตร์:",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color.fromARGB(255, 219, 218, 218),
                                focusColor: Colors.blue,
                                hintText: 'ระบุชื่อวิทยาศาสตร์',
                              ),
                              validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อวิทยาศาสตร์",
                              ).call,
                              onSaved: (String? scientificName) {
                                myHerbs.scientificName = scientificName;
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "ชื่อท้องถิ่น:",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color.fromARGB(255, 219, 218, 218),
                                focusColor: Colors.blue,
                                hintText: 'ระบุชื่อท้องถิ่น คั่นด้วย (#)',
                              ),
                              validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อท้องถิ่น",
                              ).call,
                              onSaved: (String? localName) {
                                myHerbs.localName = localName;
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "ชื่อวงศ์:",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Color.fromARGB(255, 219, 218, 218),
                                focusColor: Colors.blue,
                                hintText: 'ระบุชื่อวงศ์',
                              ),
                              validator: RequiredValidator(
                                errorText: "กรุณาป้อนชื่อวงศ์",
                              ).call,
                              onSaved: (String? familyName) {
                                myHerbs.familyName = familyName;
                              },
                            ),
                            const SizedBox(height: 15),
                            ...buildFormSections(_contactHeadFormManager),
                            const SizedBox(height: 15),
                            const Text(
                              "เพิ่มรูปภาพ:",
                              style: TextStyle(fontSize: 15),
                            ),
                            Center(
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: _pickImage,
                                color: Colors.green,
                                iconSize: 50.0,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _images != null && _images!.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                    ),
                                    itemCount: _images!.length,
                                    itemBuilder: (context, index) {
                                      return Image.file(
                                        File(_images![index].path),
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Container(),
                            const SizedBox(height: 15),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "เพิ่มข้อมูล",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                  onPressed: () async {
                                    if (_mainFormKey.currentState!.validate()) {
                                      _mainFormKey.currentState!.save();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      _showLoadingDialog();
                                      try {
                                        await _uploadImages();
                                        DocumentReference docRef =
                                            _herbsListsCollection
                                                .doc(myHerbs.namethai);
                                        await docRef.set(myHerbs.toJson());
                                        logger.d("Calling _saveAllParagraphs");
                                        await _saveAllParagraphs(
                                            docRef); // Save all paragraphs
                                        _mainFormKey.currentState!.reset();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PageHerbsList(),
                                          ),
                                        );
                                      } catch (e) {
                                        logger.e("Error uploading data: $e");
                                      } finally {
                                        _hideLoadingDialog();
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
