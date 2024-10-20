import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/contact_herbs_detail.dart';

class DetailHerbs extends StatefulWidget {
  final String id;

  const DetailHerbs({
    super.key,
    required this.id,
  });

  @override
  _DetailHerbsState createState() => _DetailHerbsState();
}

class _DetailHerbsState extends State<DetailHerbs> {
  DocumentSnapshot? documentSnapshot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      DocumentSnapshot? doc = await HerbsDetail.fetchHerbDetails(
        context: context,
        id: widget.id,
      );
      if (mounted) {
        setState(() {
          documentSnapshot = doc;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching herb details: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLoading ? 'กำลังโหลด...' : 'ข้อมูลสมุนไพร'),
          backgroundColor: Colors.green,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : documentSnapshot == null
                ? const Center(child: Text('เกิดข้อผิดพลาดในการเรียกรายการ.'))
                : _buildDetailContent(),
      ),
    );
  }

  Widget _buildDetailContent() {
    var data = documentSnapshot?.data() as Map<String, dynamic>?;

    if (data == null) {
      return const Center(child: Text('ไม่มีข้อมูลในเอกสาร.'));
    }

    var namethai = data['namethai'] as String;
    var scientificName = data['scientificName'] as String;
    var localName = data['localName'] as String? ?? '-';
    var familyName = data['familyName'] as String? ?? '-';
    var img = List<String>.from(data['img'] ?? []);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (img.isNotEmpty) _buildImageGallery(img),
            const SizedBox(height: 16.0),
            _buildInfoTable([
              {"label": "ชื่อ : ", "value": namethai},
              {"label": "ชื่อวิทยาศาสตร์: ", "value": scientificName},
              {"label": "ชื่อท้องถิ่น: ", "value": localName},
              {"label": "ชื่อวงศ์: ", "value": familyName},
            ]),
            const SizedBox(height: 16.0),
            const Divider(color: Colors.grey),
            _buildExpandableSection("ลักษณะทางกายภาพ", "Paragraph1"),
            const Divider(color: Colors.grey),
            _buildExpandableSection("สรรพคุณและประโยชน์", "Paragraph2"),
            const Divider(color: Colors.grey),
            _buildExpandableSection("วิธีใช้และศักยภาพทางยา", "Paragraph3"),
            const Divider(color: Colors.grey),
            _buildExpandableSection("คำเตือนและข้อระวัง", "Paragraph4"),
            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(List<Map<String, String>> info) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: info.map((row) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: Text(
                row["label"]!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                row["value"]!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildImageGallery(List<String> img) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: img.map((imageUrl) {
          return GestureDetector(
            onTap: () => _showImageDialog(imageUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                imageUrl,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection(String title, String paragraph) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(2),
            child: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Herbs')
                  .doc(widget.id)
                  .collection(paragraph)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }

                var docs = snapshot.data!.docs;
                return Column(
                  children: docs.map((doc) {
                    var header = doc.data() as Map<String, dynamic>;
                    var headerText = header['headerText'] as String? ?? '';
                    var headerColor =
                        header['headerColor'] as String? ?? '#000000';
                    var headerBold = header['headerBold'] as bool? ?? false;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/icons/leave.png',
                                height: 15,
                                width: 15,
                              ),
                              const SizedBox(
                                  width:
                                      8.0), // Add some space between the icon and the text
                              Expanded(
                                child: Text(
                                  headerText,
                                  style: TextStyle(
                                    color: _getColorFromHex(headerColor),
                                    fontWeight: headerBold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: doc.reference
                              .collection('subHeaders')
                              .snapshots(),
                          builder: (context, subHeaderSnapshot) {
                            if (!subHeaderSnapshot.hasData) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              );
                            }

                            var subHeaderDocs = subHeaderSnapshot.data!.docs;
                            return Column(
                              children: subHeaderDocs.map((subDoc) {
                                var subHeader =
                                    subDoc.data() as Map<String, dynamic>;
                                var subHeaderText =
                                    subHeader['subHeadText'] as String? ?? '';
                                var subHeaderColor =
                                    subHeader['subHeadColor'] as String? ??
                                        '#000000';
                                var subHeaderBold =
                                    subHeader['subHeadBold'] as bool? ?? false;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 55.0, top: 0.0, right: 16.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      subHeaderText,
                                      style: TextStyle(
                                        color: _getColorFromHex(subHeaderColor),
                                        fontWeight: subHeaderBold
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign
                                          .left, // Ensure left alignment
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
