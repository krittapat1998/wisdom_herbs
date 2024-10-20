import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/contact_head_form_manager.dart';
import 'package:wisdom_herbs/screen/form/common_header_form.dart';

List<Widget> buildFormSections(ContactFormHeadManager manager) {
  List<Widget> formSections = [];

  const sections = [
    {"title": "ลักษณะทางกายภาพ", "formType": 1},
    {"title": "สรรพคุณและประโยชน์", "formType": 2},
    {"title": "วิธีใช้และศักยภาพทางยา", "formType": 3},
    {"title": "คำเตือนและข้อระวัง", "formType": 4},
  ];

  for (var section in sections) {
    var formType = section['formType'] as int;
    var formList = manager.getFormList(formType);
    formSections.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section['title'] as String,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          // const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: formList.length,
            itemBuilder: (_, index) {
              return CommonHeaderForm(
                contactModel: formList[index],
                index: index,
                onRemove: () {
                  manager.removeForm(formType, index);
                },
                onAdd: () {
                  manager.addForm(formType);
                },
                sectionTitle: section['title'] as String,
              );
            },
          ),

          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => manager.addForm(formType),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 238, 203, 5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Paragraph',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  return formSections;
}
