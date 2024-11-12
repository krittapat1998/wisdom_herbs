// contact_menu.dart
import 'package:wisdom_herbs/models/icon_model.dart';
import 'package:wisdom_herbs/screen/page_etprise_list.dart';
import 'package:wisdom_herbs/screen/page_contact.dart';
import 'package:wisdom_herbs/screen/page_herbs_list.dart';
import 'package:wisdom_herbs/screen/page_search.dart';
import 'package:wisdom_herbs/screens/simple_screen.dart';
// import 'package:wisdom_herbs/screen/unity_ar_page%20.Dart';

List<IconModel> imaterialIcons = [
  IconModel(
    name: 'สมุนไพร',
    imagePath: 'assets/images/icons/herbslist.png',
    destination: const PageHerbsList(),
  ),
  IconModel(
    name: 'วิสาหกิจ',
    imagePath: 'assets/images/icons/cottage_.png',
    destination: const PageCommunitEnterprise(),
  ),
  IconModel(
    name: 'ค้นหา',
    imagePath: 'assets/images/icons/search.png',
    destination: const SearchHerbs(),
  ),
  IconModel(
    name: 'ติดต่อเรา',
    imagePath: 'assets/images/icons/contact_info.png',
    destination: const Contact(),
  ),
  IconModel(
    name: 'AR',
    imagePath: 'assets/images/icons/3D_AR_icon_symbol.png',
    destination: SimpleScreen(),
  ),
];
