class Herb {
  String? herbName;
  String? certification;
  String? herbPlanting;
  String? herbHarvest;
  String? areaSize;
  String? yield;
  String? pricePerKg;
  String? incomePerKg;
  String? buyer;
  String? productionCost;
  String? problems;

  Herb({
    this.herbName,
    this.certification,
    this.herbPlanting,
    this.herbHarvest,
    this.areaSize,
    this.yield,
    this.pricePerKg,
    this.incomePerKg,
    this.buyer,
    this.productionCost,
    this.problems,
  });

  Map<String, dynamic> toJson() {
    return {
      'herbName': herbName,
      'certification': certification,
      'herbPlanting': herbPlanting,
      'herbHarvest': herbHarvest,
      'areaSize': areaSize,
      'yield': yield,
      'pricePerKg': pricePerKg,
      'incomePerKg': incomePerKg,
      'buyer': buyer,
      'productionCost': productionCost,
      'problems': problems,
    };
  }

  factory Herb.fromJson(Map<String, dynamic> json) {
    return Herb(
      herbName: json['herbName'],
      certification: json['certification'],
      herbPlanting: json['herbPlanting'],
      herbHarvest: json['herbHarvest'],
      areaSize: json['areaSize'],
      yield: json['yield'],
      pricePerKg: json['pricePerKg'],
      incomePerKg: json['incomePerKg'],
      buyer: json['buyer'],
      productionCost: json['productionCost'],
      problems: json['problems'],
    );
  }
}

class HerbsType {
  List<Herb>? herbs;

  HerbsType({this.herbs});

  Map<String, dynamic> toJson() {
    return {
      'herbs': herbs?.map((e) => e.toJson()).toList(),
    };
  }

  factory HerbsType.fromJson(Map<String, dynamic> json) {
    return HerbsType(
      herbs: (json['herbs'] as List<dynamic>?)
          ?.map((e) => Herb.fromJson(e))
          .toList(),
    );
  }
}

class EnterpriseLists {
  String? groupName;
  String? groupLocation;
  List<String>? img;
  String? contactName;
  String? phoneNumber;
  String? lineID;
  String? address;
  String? subdistrict;
  String? district;
  String? province;
  String? postalCode;
  String? affiliation;
  String? enterpriseHistory;
  String? groupOperations;
  String? membershipAndOrganization;
  String? qualitycontrol;
  String? herbTypesCount;
  String? soldThroughLocal;
  String? soldThroughOnline;
  String? exportSales;
  String? CreatingAgreementsPrices;
  Map<String, HerbsType>? herbsTypes;

  EnterpriseLists({
    this.groupName,
    this.groupLocation,
    this.img,
    this.contactName,
    this.phoneNumber,
    this.lineID,
    this.address,
    this.subdistrict,
    this.district,
    this.province,
    this.postalCode,
    this.affiliation,
    this.enterpriseHistory,
    this.groupOperations,
    this.membershipAndOrganization,
    this.qualitycontrol,
    this.herbTypesCount,
    this.soldThroughLocal,
    this.soldThroughOnline,
    this.exportSales,
    this.CreatingAgreementsPrices,
    this.herbsTypes,
  });

  Map<String, dynamic> toJson() => {
        'groupName': groupName,
        'groupLocation': groupLocation,
        'img': img,
        'contactName': contactName,
        'phoneNumber': phoneNumber,
        'lineID': lineID,
        'address': address,
        'subdistrict': subdistrict,
        'district': district,
        'province': province,
        'postalCode': postalCode,
        'affiliation': affiliation,
        'enterpriseHistory': enterpriseHistory,
        'groupOperations': groupOperations,
        'membershipAndOrganization': membershipAndOrganization,
        'qualitycontrol': qualitycontrol,
        'herbTypesCount': herbTypesCount,
        'soldThroughLocal': soldThroughLocal,
        'soldThroughOnline': soldThroughOnline,
        'exportSales': exportSales,
        'CreatingAgreementsPrices': CreatingAgreementsPrices,
        'herbsTypes': herbsTypes?.map((k, v) => MapEntry(k, v.toJson())),
      };

  factory EnterpriseLists.fromJson(Map<String, dynamic> json) {
    return EnterpriseLists(
      groupName: json['groupName'],
      groupLocation: json['groupLocation'],
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
      contactName: json['contactName'],
      phoneNumber: json['phoneNumber'],
      lineID: json['lineID'],
      address: json['address'],
      subdistrict: json['subdistrict'],
      district: json['district'],
      province: json['province'],
      postalCode: json['postalCode'],
      affiliation: json['affiliation'],
      enterpriseHistory: json['enterpriseHistory'],
      groupOperations: json['groupOperations'],
      membershipAndOrganization: json['membershipAndOrganization'],
      qualitycontrol: json['qualitycontrol'],
      herbTypesCount: json['herbTypesCount'],
      soldThroughLocal: json['soldThroughLocal'],
      soldThroughOnline: json['soldThroughOnline'],
      exportSales: json['exportSales'],
      CreatingAgreementsPrices: json['CreatingAgreementsPrices'],
      herbsTypes: (json['herbsTypes'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, HerbsType.fromJson(v)),
      ),
    );
  }
}
