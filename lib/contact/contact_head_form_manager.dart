import 'package:flutter/material.dart';
import 'package:wisdom_herbs/models/herb_models.dart';

class ContactFormHeadManager {
  final Map<int, List<Header>> formLists = {};
  final Function() notifyParent;
  final List<GlobalKey<FormState>> formKeys = [];

  ContactFormHeadManager(this.notifyParent);

  List<Header> getFormList(int formType) {
    return formLists[formType] ?? [];
  }

  void addForm(int formType) {
    if (!formLists.containsKey(formType)) {
      formLists[formType] = [];
    }
    formLists[formType]!.add(Header(
      headerText: '',
      headerBold: false,
      subHeaders: [],
    ));
    formKeys.add(GlobalKey<FormState>());
    notifyParent();
  }

  void removeForm(int formType, int index) {
    formLists[formType]?.removeAt(index);
    formKeys.removeAt(index);
    notifyParent();
  }

  bool validateAllForms() {
    bool allValid = true;
    formLists.forEach((formType, headers) {
      for (var header in headers) {
        if (header.headerText == null || header.headerText!.trim().isEmpty) {
          allValid = false;
        }
      }
    });
    for (var formKey in formKeys) {
      if (!formKey.currentState!.validate()) {
        allValid = false;
      }
    }
    return allValid;
  }

  Map<int, List<Header>> getAllForms() {
    return formLists;
  }
}
