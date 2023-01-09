import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/notification_model.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class NotificationProvider with ChangeNotifier {
  bool isLoaded = false;
  List<NotificationModel> notifications = [];

  Future<ResponseClass<List<NotificationModel>>> getNotifications(
      int page) async {
    String url = StringConstants.apiUrl + StringConstants.getAllNotification;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    var data = {
      "marriage_id": marriageId,
      // "guest_id": sharedPrefs.guestId,
      "page": page,
      "limit": 10
    };

    //Response
    ResponseClass<List<NotificationModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: notifications);
    try {
      Response response = await dio.get(
        url,
        queryParameters: data,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
              Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List notificationList = response.data["data"];
        List<NotificationModel> list =
            notificationList.map((e) => NotificationModel.fromJson(e)).toList();
        responseClass.data = list;
        if (page == 1) {
          notifications = list;
        } else {
          notifications.addAll(list);
        }
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
        log("Notification error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
