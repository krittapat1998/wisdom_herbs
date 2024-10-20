import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/add_etprise_firebase.dart';
import 'package:wisdom_herbs/contact/add_herbs_firebase.dart';
import 'package:wisdom_herbs/screen/form/main_form_herbs.dart';

class MenuDrawer extends StatelessWidget {
  final String? firestorePassword;

  const MenuDrawer({super.key, this.firestorePassword});

  void _showPasswordPrompt(BuildContext context, Function onSuccess) {
    final TextEditingController passwordController = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('กรอกรหัสนักพัฒนา'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'รหัสผ่าน',
                      errorText: errorText,
                    ),
                  ),
                ],
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
                    if (passwordController.text == firestorePassword) {
                      Navigator.of(context).pop();
                      onSuccess();
                    } else {
                      setState(() {
                        errorText = 'รหัสผ่านผิดพลาด';
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addHerbs(BuildContext context) async {
    await AddHerbsFirebase.addHerbsFromFile(context);
    if (context.mounted) {
      Navigator.of(context).pop(); // Close the drawer
    }
  }

  Future<void> _addEnterprise(BuildContext context) async {
    await AddEnterpriselistsFirebase.addEnterpriselistsFromFile(context);
    if (context.mounted) {
      Navigator.of(context).pop(); // Close the drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text('Wisdom Herbs'),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('จัดการข้อมูลสมุนไพร'),
              onTap: () => _showPasswordPrompt(context, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormHerbs(),
                  ),
                );
              }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('เพิ่มรายการสมุนไพร'),
              onTap: () =>
                  _showPasswordPrompt(context, () => _addHerbs(context)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('เพิ่มรายการวิสาหกิจ'),
              onTap: () =>
                  _showPasswordPrompt(context, () => _addEnterprise(context)),
            ),
          ),
        ],
      ),
    );
  }
}
