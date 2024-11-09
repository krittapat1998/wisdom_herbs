import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wisdom_herbs/contact/dark_pass.dart';
import 'package:wisdom_herbs/screen/drawer_menu.dart';
import 'package:wisdom_herbs/screen/detail_etprise.dart';

class PageCommunitEnterprise extends StatefulWidget {
  const PageCommunitEnterprise({super.key});

  @override
  State<PageCommunitEnterprise> createState() => _PageCommunitEnterpriseState();
}

class _PageCommunitEnterpriseState extends State<PageCommunitEnterprise> {
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();
  String? firestorePassword;
  bool isLoading = true;
  List<QueryDocumentSnapshot> docs = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    firestorePassword =
        await DarkPass.fetchPasswordFromFirestore(context: context);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("วิสาหกิจชุมชน"),
        backgroundColor: Colors.green,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("EnterpriseGroup")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                docs = snapshot.data!.docs
                  ..sort((a, b) => (a['groupName'] as String)
                      .compareTo(b['groupName'] as String));

                if (docs.isEmpty) {
                  return const Center(child: Text('ไม่พบข้อมูล'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final imgList =
                        (doc['img'] as List<dynamic>?)?.cast<String>();
                    return Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 5),
                      child: ListTile(
                        leading: imgList != null && imgList.isNotEmpty
                            ? Image.network(imgList[0])
                            : null,
                        title: Text(
                          doc['groupName'], // Use doc.id to display the document ID
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(doc['groupLocation']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailEtprise(id: doc.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
