// menu_box.dart
import 'package:flutter/material.dart';

class MenuBox extends StatelessWidget {
  const MenuBox({
    super.key, // Use super.key here
    required this.name,
    required this.imagePath,
    required this.destination,
  });
  final String name;
  final String imagePath;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imagePath, width: 120.0, height: 120.0),
            Text(name,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
