import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/events_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class EventProvider with ChangeNotifier {
  bool isLoaded = false;
  List<EventModel> events = [];
  int currentIndex = 0;

  getEvents() async {
    String url = StringConstants.apiUrl +
        StringConstants.getAllEventForGuest +
        "/$marriageId";

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List eventList = response.data["data"];
        List<EventModel> list =
            eventList.map((e) => EventModel.fromJson(e)).toList();
        events = list;
        isLoaded = true;
        notifyListeners();
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("event error ->" + e.toString());
      }
    }
  }
}
