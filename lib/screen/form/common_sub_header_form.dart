import 'package:flutter/material.dart';
import 'package:wisdom_herbs/models/herb_models.dart';

class ContactSubHeadFormItemWidget extends StatefulWidget {
  ContactSubHeadFormItemWidget({
    super.key,
    required this.contactModel,
    required this.onRemove,
    required this.index,
    required this.headerIndex,
  });

  final int headerIndex;
  final int index;
  final SubHeader contactModel;
  final Function onRemove;

  @override
  // ignore: library_private_types_in_public_api
  _ContactSubHeadFormItemWidgetState createState() =>
      _ContactSubHeadFormItemWidgetState();

  bool validate() => state.validate();

  final state = _ContactSubHeadFormItemWidgetState();
  final TextEditingController _subNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
}

class _ContactSubHeadFormItemWidgetState
    extends State<ContactSubHeadFormItemWidget> {
  final subHeadFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Form(
        key: subHeadFormKey,
        child: Container(
          padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 197, 196, 196),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ลักษณะทางกายภาพ : ${widget.headerIndex} (SubHead ${widget.index})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                title: const Text(
                  'header text : ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: TextFormField(
                  controller: widget._subNameController,
                  onChanged: (value) => widget.contactModel.subHeadText = value,
                  onSaved: (value) => widget.contactModel.subHeadText = value,
                  validator: (value) =>
                      value!.length > 3 ? null : "ระบุข้อความ",
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(
                        255, 240, 240, 240), // Set the background color here
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "ระบุข้อความ",
                    // labelText: "header text : ",
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "header color : ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: widget._contactController,
                      onChanged: (value) =>
                          widget.contactModel.subHeadColor = value,
                      onSaved: (value) =>
                          widget.contactModel.subHeadColor = value,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 240, 240,
                            240), // Set the background color here
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(),
                        hintText: "ระบุรหัสสี (ไม่ระบุก็ได้)",
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "headerBold : ",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Checkbox(
                    value: widget.contactModel.subHeadBold,
                    onChanged: (value) {
                      setState(() {
                        widget.contactModel.subHeadBold = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool validate = subHeadFormKey.currentState!.validate();
    if (validate) {
      subHeadFormKey.currentState!.save();
    }
    return validate;
  }
}
