import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wisdom_herbs/contact/dark_pass.dart';
import 'package:wisdom_herbs/screen/detail_etprise.dart';
import 'package:wisdom_herbs/screen/detail_herbs.dart';
import 'package:wisdom_herbs/screen/drawer_menu.dart';
import 'package:rxdart/rxdart.dart';

class SearchHerbs extends StatefulWidget {
  const SearchHerbs({super.key});

  @override
  State<SearchHerbs> createState() => _SearchHerbsState();
}

class _SearchHerbsState extends State<SearchHerbs> {
  final logger = Logger();
  final keyword = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _searchBoxKey = GlobalKey();
  String? firestorePassword;
  bool isLoading = true;
  Map<String, List<Map<String, dynamic>>> sortedGroupedDocs = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    keyword.dispose();
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

  String _getConsonantGroup(String namethai) {
    const thaiConsonants = 'กขคฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรลวศษสหฬอฮ';
    const thaiVowels = 'เแโใไ';

    String firstChar = namethai.isNotEmpty ? namethai[0] : '';
    if (thaiVowels.contains(firstChar)) {
      if (namethai.length > 1 && thaiConsonants.contains(namethai[1])) {
        firstChar = namethai[1];
      }
    }
    return thaiConsonants.contains(firstChar) ? firstChar : 'อื่นๆ';
  }

  void _scrollToConsonant(String consonant) {
    int offset = 0;
    for (var key in sortedGroupedDocs.keys) {
      if (key == consonant) {
        break;
      }
      offset += (sortedGroupedDocs[key]!.length + 1) * 60; // Approx height
    }

    // Adjust offset to not be hidden by the search bar
    final searchBoxContext = _searchBoxKey.currentContext;
    if (searchBoxContext != null) {
      RenderBox searchBox = searchBoxContext.findRenderObject() as RenderBox;
      offset -= searchBox.size.height.toInt();
    }

    _scrollController.animateTo(
      offset.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ค้นหาสมุนไพรและวิสาหกิจชุมชน"),
        backgroundColor: Colors.green,
      ),
      drawer: MenuDrawer(firestorePassword: firestorePassword),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              key: _searchBoxKey,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: keyword,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "ค้นหาสมุนไพรและวิสาหกิจชุมชน",
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<QuerySnapshot>>(
              stream: CombineLatestStream.list([
                FirebaseFirestore.instance.collection("Herbs").snapshots(),
                FirebaseFirestore.instance
                    .collection("EnterpriseGroup")
                    .snapshots(),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final herbsDocs = snapshot.data![0].docs.where((doc) {
                  final namethai = doc['namethai']?.toLowerCase() ?? '';
                  final scientificName =
                      doc['scientificName']?.toLowerCase() ?? '';
                  final searchText = keyword.text.toLowerCase();
                  return namethai.contains(searchText) ||
                      scientificName.contains(searchText);
                }).toList()
                  ..sort((a, b) => (a['namethai'] as String)
                      .compareTo(b['namethai'] as String));

                final enterpriseDocs = snapshot.data![1].docs.where((doc) {
                  final groupName = doc['groupName']?.toLowerCase() ?? '';
                  final groupLocation =
                      doc['groupLocation']?.toLowerCase() ?? '';
                  final searchText = keyword.text.toLowerCase();
                  return groupName.contains(searchText) ||
                      groupLocation.contains(searchText);
                }).toList()
                  ..sort((a, b) => (a['groupName'] as String)
                      .compareTo(b['groupName'] as String));

                final allDocs = [
                  ...herbsDocs.map((doc) => {
                        'title': doc['namethai'],
                        'subtitle': doc['scientificName'],
                        'img': (doc['img'] as List<dynamic>?)?.cast<String>(),
                        'type': 'herb',
                        'id': doc.id,
                      }),
                  ...enterpriseDocs.map((doc) => {
                        'title': doc['groupName'],
                        'subtitle': doc['groupLocation'],
                        'img': (doc['img'] as List<dynamic>?)?.cast<String>(),
                        'type': 'enterprise',
                        'id': doc.id,
                      }),
                ];

                final Map<String, List<Map<String, dynamic>>> groupedDocs = {};
                for (var doc in allDocs) {
                  final firstConsonant =
                      _getConsonantGroup(doc['title']?.toUpperCase() ?? '');
                  if (!groupedDocs.containsKey(firstConsonant)) {
                    groupedDocs[firstConsonant] = [];
                  }
                  groupedDocs[firstConsonant]!.add(doc);
                }

                sortedGroupedDocs = Map.fromEntries(
                  groupedDocs.entries.toList()
                    ..sort((a, b) {
                      const thaiAlphabet =
                          'กขคฆงจฉชซฌญฎฏฐฑฒณดตถทธนบปผฝพฟภมยรลวศษสหฬอฮ';
                      if (thaiAlphabet.contains(a.key) &&
                          !thaiAlphabet.contains(b.key)) {
                        return -1;
                      } else if (!thaiAlphabet.contains(a.key) &&
                          thaiAlphabet.contains(b.key)) {
                        return 1;
                      } else {
                        return a.key.compareTo(b.key);
                      }
                    }),
                );

                if (sortedGroupedDocs.isEmpty) {
                  return const Center(child: Text('ไม่พบข้อมูล'));
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        children: sortedGroupedDocs.entries.map((entry) {
                          return Column(
                            key: ValueKey(entry.key),
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...entry.value.map((doc) {
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: ListTile(
                                    leading: doc['img'] != null &&
                                            doc['img'].isNotEmpty
                                        ? SizedBox(
                                            width:
                                                60, // กำหนดความกว้างของรูปภาพ
                                            height: 60, // กำหนดความสูงของรูปภาพ
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // ทำให้รูปภาพมีมุมโค้ง
                                              child: Image.network(
                                                doc['img'][0],
                                                fit: BoxFit
                                                    .cover, // ทำให้รูปภาพครอบคลุมพื้นที่ทั้งหมด
                                              ),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Icon(Icons.image,
                                                color: Colors
                                                    .grey), // แสดงไอคอนแทนหากไม่มีรูป
                                          ),
                                    title: Text(
                                      doc['title'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(doc['subtitle']),
                                    onTap: () {
                                      if (doc['type'] == 'herb') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailHerbs(id: doc['id']),
                                          ),
                                        );
                                      } else if (doc['type'] == 'enterprise') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailEtprise(id: doc['id']),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: sortedGroupedDocs.keys.map((consonant) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  _scrollToConsonant(consonant);
                                },
                                child: Text(consonant),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
