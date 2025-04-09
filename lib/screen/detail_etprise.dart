import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/contact_etprose_detail.dart';

class DetailEtprise extends StatefulWidget {
  final String id;

  const DetailEtprise({
    super.key,
    required this.id,
  });

  @override
  _DetailEtpriseState createState() => _DetailEtpriseState();
}

class _DetailEtpriseState extends State<DetailEtprise> {
  DocumentSnapshot? documentSnapshot;
  bool isLoading = true;
  Map<String, bool> herbsTypesAvailability = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      DocumentSnapshot? doc = await EtpriseDetail.fetchEtpriseDetails(
        context: context,
        id: widget.id,
      );
      if (mounted) {
        setState(() {
          documentSnapshot = doc;
          isLoading = false;
        });

        if (doc != null) {
          await _checkHerbsTypesAvailability();
        }
      }
    } catch (e) {
      //print("Error fetching Etprise details: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _checkHerbsTypesAvailability() async {
    List<String> herbsTypesKeys = [
      'herbsType1',
      'herbsType2',
      'herbsType3',
      'herbsType4',
      'herbsType5'
    ];

    for (var herbsTypeKey in herbsTypesKeys) {
      var snapshot = await FirebaseFirestore.instance
          .collection('EnterpriseGroup')
          .doc(widget.id)
          .collection(herbsTypeKey)
          .get();

      setState(() {
        herbsTypesAvailability[herbsTypeKey] = snapshot.docs.isNotEmpty;
      });
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
          title: Text(isLoading ? 'กำลังโหลด...' : 'ข้อมูลวิสาหกิจชุมชน'),
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

    var groupName = data['groupName'] as String;
    var contactName = data['contactName'] as String;
    var phoneNumber = data['phoneNumber'] as String? ?? '-';
    var groupLocation = data['groupLocation'] as String? ?? '-';
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
              {"label": "ชื่อ : ", "value": groupName},
              {"label": "ผู้ให้ข้อมูล ", "value": contactName},
              {"label": "เบอร์: ", "value": phoneNumber},
              {"label": "สถานที่ก่อตั้ง: ", "value": groupLocation},
            ]),
            const SizedBox(height: 16.0),
            const Divider(color: Colors.grey),
            if (herbsTypesAvailability['herbsType1'] == true)
              _buildExpandableSection("สมุนไพรชนิดที่ 1", "herbsType1"),
            if (herbsTypesAvailability['herbsType1'] == true)
              const Divider(color: Colors.grey),
            if (herbsTypesAvailability['herbsType2'] == true)
              _buildExpandableSection("สมุนไพรชนิดที่ 2", "herbsType2"),
            if (herbsTypesAvailability['herbsType2'] == true)
              const Divider(color: Colors.grey),
            if (herbsTypesAvailability['herbsType3'] == true)
              _buildExpandableSection("สมุนไพรชนิดที่ 3", "herbsType3"),
            if (herbsTypesAvailability['herbsType3'] == true)
              const Divider(color: Colors.grey),
            if (herbsTypesAvailability['herbsType4'] == true)
              _buildExpandableSection("สมุนไพรชนิดที่ 4", "herbsType4"),
            if (herbsTypesAvailability['herbsType4'] == true)
              const Divider(color: Colors.grey),
            if (herbsTypesAvailability['herbsType5'] == true)
              _buildExpandableSection("สมุนไพรชนิดที่ 5", "herbsType5"),
            if (herbsTypesAvailability['herbsType5'] == true)
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

  Widget _buildExpandableSection(String title, String herbsTypes) {
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
                  .collection('EnterpriseGroup')
                  .doc(widget.id)
                  .collection(herbsTypes)
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
                    var herbs = doc.data() as Map<String, dynamic>;
                    var herbName = herbs['herbName'] as String? ?? '';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset(
                            'assets/images/icons/oregano2.png',
                            height: 15,
                            width: 15,
                          ),
                          title: Text(
                            herbName,
                          ),
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
}
