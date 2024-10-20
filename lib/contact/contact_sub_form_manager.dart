import 'package:flutter/material.dart';
import 'package:wisdom_herbs/models/herb_models.dart';
import 'package:wisdom_herbs/screen/form/common_sub_header_form.dart';

class ContactFormSubHeadManager {
  final List<ContactSubHeadFormItemWidget> contactSubHeadForms = [];
  final Function() notifyParent;
  final int headerIndex;
  final List<SubHeader> subHeaders;

  ContactFormSubHeadManager(
      this.notifyParent, this.headerIndex, this.subHeaders);

  void onAdd() {
    SubHeader contactModelSubHead = SubHeader(
      subHeadText: '',
    );

    subHeaders.add(contactModelSubHead);

    contactSubHeadForms.add(ContactSubHeadFormItemWidget(
      key: UniqueKey(),
      index: contactSubHeadForms.length,
      contactModel: contactModelSubHead,
      onRemove: () => onRemove(contactModelSubHead),
      headerIndex: headerIndex,
    ));
    notifyParent();
  }

  void onRemove(SubHeader contact) {
    int index = contactSubHeadForms.indexWhere(
      (element) => element.contactModel.subHeadText == contact.subHeadText,
    );
    if (index != -1) {
      contactSubHeadForms.removeAt(index);
      subHeaders.remove(contact);
      notifyParent();
    }
  }

  bool isAllSubHeadsValidated() {
    for (var subHeadForm in contactSubHeadForms) {
      if (!subHeadForm.validate()) {
        return false;
      }
    }
    return true;
  }
}
