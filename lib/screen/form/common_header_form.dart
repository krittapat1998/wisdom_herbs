import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wisdom_herbs/contact/contact_sub_form_manager.dart';
import 'package:wisdom_herbs/models/herb_models.dart';
import 'package:wisdom_herbs/screen/form/common_sub_header_form.dart';

class CommonHeaderForm extends StatefulWidget {
  final int index;
  final Header contactModel;
  final Function onRemove;
  final Function onAdd;
  final String sectionTitle;

  CommonHeaderForm({
    Key? key,
    required this.contactModel,
    required this.onRemove,
    required this.index,
    required this.onAdd,
    required this.sectionTitle,
  }) : super(key: key);

  @override
  _CommonHeaderFormState createState() => _CommonHeaderFormState();

  bool isValidated() => _CommonHeaderFormState().validate();

  List<ContactSubHeadFormItemWidget> get contactSubHeadForms =>
      _CommonHeaderFormState().contactSubHeadForms;
}

class _CommonHeaderFormState extends State<CommonHeaderForm> {
  final headerFormKey = GlobalKey<FormState>();
  late ContactFormSubHeadManager _contactSubHeadFormManager;
  List<ContactSubHeadFormItemWidget> contactSubHeadForms = [];
  Color headerColor = Colors.white; // Default color

  @override
  void initState() {
    super.initState();
    // Ensure subHeaders is initialized
    if (widget.contactModel.subHeaders == null) {
      widget.contactModel.subHeaders = [];
    }
    _contactSubHeadFormManager = ContactFormSubHeadManager(
      _updateUI,
      widget.index,
      widget.contactModel.subHeaders!,
    );

    // Initialize headerColor from contactModel
    headerColor =
        Color(int.parse(widget.contactModel.headerColor ?? '0xFFFFFFFF'));
  }

  void _updateUI() {
    setState(() {});
  }

  void _selectColor() async {
    Color selectedColor = headerColor;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกสี Header'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: headerColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                setState(() {
                  headerColor = selectedColor;
                  widget.contactModel.headerColor =
                      headerColor.value.toRadixString(16);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Form(
          key: headerFormKey,
          child: Container(
            padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 223, 222, 222),
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
                      "${widget.sectionTitle} : ${widget.index}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.contactModel.headerText = "";
                              widget.contactModel.headerColor = "";
                              widget.contactModel.headerBold = false;
                            });
                          },
                          child: const Text(
                            "รีเซ็ต",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onRemove();
                          },
                          child: const Text(
                            "ลบ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
                    controller: TextEditingController(
                        text: widget.contactModel.headerText),
                    onChanged: (value) =>
                        widget.contactModel.headerText = value,
                    onSaved: (value) => widget.contactModel.headerText = value,
                    validator: (value) =>
                        value != null && value.trim().isNotEmpty
                            ? null
                            : "กรุณาป้อนข้อความ",
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 240, 240, 240),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "ระบุข้อความ",
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
                      child: InkWell(
                        onTap: _selectColor,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: headerColor,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                      value: widget.contactModel.headerBold,
                      onChanged: (value) {
                        setState(() {
                          widget.contactModel.headerBold = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      _contactSubHeadFormManager.contactSubHeadForms.length,
                  itemBuilder: (_, index) {
                    return _contactSubHeadFormManager
                        .contactSubHeadForms[index];
                  },
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _contactSubHeadFormManager.onAdd();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Colors.blue,
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
                            'SubHead',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool validate = headerFormKey.currentState!.validate();
    if (validate) {
      headerFormKey.currentState!.save();
      return _contactSubHeadFormManager.isAllSubHeadsValidated();
    }
    return false;
  }
}
