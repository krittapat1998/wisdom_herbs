import 'package:flutter/material.dart';

class IconModel {
  final String? imagePath;
  final String? name;
  final Widget? destination;

  IconModel(
      {required this.name, required this.imagePath, required this.destination});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = imagePath;
    data['name'] = name;
    data['destination'] = destination;
    return data;
  }
}
