import 'package:cloud_firestore/cloud_firestore.dart';

class Header {
  String? headerText;
  String? headerColor;
  bool? headerBold;
  List<SubHeader>? subHeaders;

  Header({
    this.headerText,
    this.headerColor,
    this.headerBold = false,
    this.subHeaders,
  });

  Map<String, dynamic> toJson() {
    return {
      'headerText': headerText,
      'headerBold': headerBold,
      'headerColor': headerColor,
    };
  }

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      headerText: json['headerText'],
      headerColor: json['headerColor'],
      headerBold: json['headerBold'],
      subHeaders: (json['subHeaders'] as List<dynamic>?)
          ?.map((e) => SubHeader.fromJson(e))
          .toList(),
    );
  }
}

class SubHeader {
  String? subHeadText;
  String? subHeadColor;
  bool? subHeadBold;

  SubHeader({
    this.subHeadText,
    this.subHeadColor,
    this.subHeadBold = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'subHeadText': subHeadText,
      'subHeadBold': subHeadBold,
      'subHeadColor': subHeadColor,
    };
  }

  factory SubHeader.fromJson(Map<String, dynamic> json) {
    return SubHeader(
      subHeadText: json['subHeadText'],
      subHeadColor: json['subHeadColor'],
      subHeadBold: json['subHeadBold'],
    );
  }
}

class HerbsLists {
  String? namethai;
  String? scientificName;
  List<String>? img;
  String? localName;
  String? familyName;
  DateTime? date;
  List<Header>? headers;

  HerbsLists({
    this.namethai,
    this.scientificName,
    this.img,
    this.localName,
    this.familyName,
    this.date,
    this.headers,
  });

  Map<String, dynamic> toJson() => {
        'namethai': namethai,
        'scientificName': scientificName,
        'img': img,
        'localName': localName,
        'familyName': familyName,
        'date': date != null ? Timestamp.fromDate(date!) : null,
      };

  factory HerbsLists.fromJson(Map<String, dynamic> json) {
    return HerbsLists(
      namethai: json['namethai'],
      scientificName: json['scientificName'],
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
      localName: json['localName'],
      familyName: json['familyName'],
      date: (json['date'] as Timestamp?)?.toDate(),
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(e))
          .toList(),
    );
  }
}
