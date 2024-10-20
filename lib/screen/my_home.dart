import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/dark_pass.dart';
import 'package:wisdom_herbs/models/menu_box.dart';
import 'package:wisdom_herbs/screen/drawer_menu.dart';
import 'package:wisdom_herbs/contact/contact_menu.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.style});

  final String title;
  final TextStyle style;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? firestorePassword;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    firestorePassword =
        await DarkPass.fetchPasswordFromFirestore(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: widget.style), // Apply the style here
        backgroundColor: Colors.green, // Ensure this is different from white
      ),
      drawer: MenuDrawer(firestorePassword: firestorePassword),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/HerbsLogo2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          const Divider(
            height: 20.0,
            thickness: 3.0,
            color: Color.fromARGB(198, 95, 95, 95),
            indent: 25.0,
            endIndent: 25.0,
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return MenuBox(
                  name: imaterialIcons[index].name!,
                  imagePath: imaterialIcons[index].imagePath!,
                  destination: imaterialIcons[index].destination!,
                );
              },
              itemCount: imaterialIcons.length,
            ),
          ),
        ],
      ),
    );
  }
}
