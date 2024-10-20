import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ติดต่อเรา"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/icons/HerbsLogo1.png',
                  height: 250,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '      แอปพลิเคชัน Wisdom of Herbs in Sakaeo ได้ถูกพัฒนาขึ้นเพื่อใช้เผยแพร่คลังข้อมูลสมุนไพรของวิสาหกิจชุมชนในจังหวัดสระแก้ว  ซึ่งสามารถดาวน์โหลดเพื่อติดตั้งใช้งานได้ทั้งระบบปฏิบัติการแอนดรอยด์ (Android) และระบบปฏิบัติการไอโอเอส (iOS)  แอปพลิเคชันนี้ถูกพัฒนาโดยทีมงานวิจัย คณะวิทยาศาสตร์และสังคมศาสตร์ มหาวิทยาลัยบูรพา วิทยาเขตสระแก้ว  ภายใต้งานวิจัยโครงการการพัฒนานวัตกรรมเทคโนโลยีความเป็นจริงเสริมในการจัดการคลังความรู้ภูมิปัญญาท้องถิ่นด้านสมุนไพรของวิสาหกิจชุมชนในจังหวัดสระแก้ว  โดยได้รับงบประมาณสนับสนุนจากกระทรวงการอุดมศึกษา วิทยาศาสตร์ วิจัยและนวัตกรรม งบประมาณด้าน ววน. ประเภท Fundamental Fund ประจำปีงบประมาณ 2566 หน่วยงาน มหาวิทยาลัยบูรพา',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'วัตถุประสงค์',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const ObjectiveListItem(
                  number: 1,
                  text:
                      'เพื่อศึกษาสภาพการจัดการคลังความรู้ภูมิปัญญาท้องถิ่นด้านสมุนไพรในวิสาหกิจชุมชนในจังหวัดสระแก้ว'),
              const ObjectiveListItem(
                  number: 2,
                  text:
                      'เพื่อพัฒนานวัตกรรมเทคโนโลยีความเป็นจริงเสริมในการจัดการคลังความรู้ภูมิปัญญาท้องถิ่นด้านสมุนไพรของวิสาหกิจชุมชน'),
              const ObjectiveListItem(
                  number: 3,
                  text:
                      'เพื่อถ่ายทอดนวัตกรรมเทคโนโลยีความเป็นจริงเสริมในการจัดการคลังความรู้ภูมิปัญญาท้องถิ่นด้านสมุนไพรในวิสาหกิจชุมชนในจังหวัดสระแก้ว'),
              const SizedBox(height: 16),
              const Text(
                'ช่องทางการติดต่อ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/icons/user_0.png',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ผู้ช่วยศาสตราจารย์ ดร.นงนุช ศรีสุข',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/icons/email_0.png',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'nongnuchsr@buu.ac.th',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/icons/school_0.png',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'คณะวิทยาศาสตร์และสังคมศาสตร์\nมหาวิทยาลัยบูรพา วิทยาเขตสระแก้ว\n254 หมู่ 4 ถนนสุวรรณศร ตำบลวัฒนานคร\nอำเภอวัฒนานคร จังหวัดสระแก้ว 27160',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ObjectiveListItem extends StatelessWidget {
  final int number;
  final String text;

  const ObjectiveListItem({required this.number, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: const TextStyle(fontSize: 16),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
