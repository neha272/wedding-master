import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/general/string_constants.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<bool> logout() async {
    _sharedPrefs!.clear();
    if (sharedPrefs.guestId.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  //getter
  String get mobileNo =>
      _sharedPrefs!.getString(StringConstants.mobileNo) ?? "";

  String get guestId => _sharedPrefs!.getString(StringConstants.guestId) ?? "";

  String get guestName =>
      _sharedPrefs!.getString(StringConstants.guestName) ?? "";

  String get guestProfileImage =>
      _sharedPrefs!.getString(StringConstants.guestProfileImage) ?? "";

  List<String> get guestIdProof =>
      _sharedPrefs!.getStringList(StringConstants.guestIdProof) ?? [];

  String get primaryTheme =>
      _sharedPrefs!.getString(StringConstants.primaryTheme) ?? "";

  //setter
  set mobileNo(String value) {
    _sharedPrefs!.setString(StringConstants.mobileNo, value);
  }

  set guestId(String value) {
    _sharedPrefs!.setString(StringConstants.guestId, value);
  }

  set guestName(String value) {
    _sharedPrefs!.setString(StringConstants.guestName, value);
  }

  set guestProfileImage(String value) {
    _sharedPrefs!.setString(StringConstants.guestProfileImage, value);
  }

  set guestIdProof(List<String> value) {
    _sharedPrefs!.setStringList(StringConstants.guestIdProof, value);
  }

  set primaryTheme(String value) {
    _sharedPrefs!.setString(StringConstants.primaryTheme, value);
  }

  /*--------------- Check Is Login or Not --------------------*/
  Future<bool> isLogin() async {
    String guestId = sharedPrefs.guestId;
    if (guestId == "" || guestId.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}

final sharedPrefs = SharedPrefs();
