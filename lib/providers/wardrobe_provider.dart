import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/models/wardrobe_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class WardrobeProvider with ChangeNotifier {
  bool isLoaded = false;
  List<WardrobeModel> wardrobes = [];

  Future<ResponseClass<List<WardrobeModel>>> getWardrobe() async  {
    String url = StringConstants.apiUrl +
        StringConstants.getAllEventWardrobeForGuest +
        "/$marriageId";
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //Response
    ResponseClass<List<WardrobeModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: wardrobes);
    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        List eventList = response.data["data"];
        List<WardrobeModel> list =
            eventList.map((e) => WardrobeModel.fromJson(e)).toList();
        responseClass.data = list;
        wardrobes = list;
        isLoaded = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("event error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
