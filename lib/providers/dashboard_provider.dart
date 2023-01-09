import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/dashboard_model.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoaded = false;
  DashboardModel? dashboardModel;

  Future<ResponseClass<DashboardModel>> getDashboard() async {
    String url = StringConstants.apiUrl +
        StringConstants.getMarriagesInformation +
        "/$marriageId";

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    //Response
    ResponseClass<DashboardModel> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: dashboardModel);
    try {
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = DashboardModel.fromJson(response.data["data"]);
        dashboardModel = responseClass.data;

        isLoaded = true;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      log(e.toString());
      isLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } on SocketException catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("dashboard error ->" + e.toString());
      }
      Fluttertoast.showToast(msg: "No internet");
      return responseClass;
    } catch (e) {
      isLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("dashboard error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
