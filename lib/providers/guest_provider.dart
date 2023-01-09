import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/guest_model.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

class GuestProvider extends ChangeNotifier {
  GuestModel? guest;
  bool isLoading = false;

  Future<ResponseClass<GuestModel>> getGuestData(
      {required String guestId}) async {
    String loginUrl =
        StringConstants.apiUrl + StringConstants.getGuestApprovedFeed;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    var data = {"guest_id": guestId, "user_id": sharedPrefs.guestId};
    //Response
    ResponseClass<GuestModel> responseClass = ResponseClass(
      success: false,
      message: "Something went wrong",
    );
    try {
      isLoading = true;
      notifyListeners();
      Response response = await dio.get(
        loginUrl,
        queryParameters: data,
        options: Options(validateStatus: (status) {
          return status == 401 || status == 200;
        }),
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = GuestModel.fromJson(response.data["data"]);
        guest = responseClass.data;
        isLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 401) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        Fluttertoast.showToast(msg: responseClass.message);
        guest =
            GuestModel(guestName: "WeWed", guestProfileImage: "", feeds: []);

        isLoading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isLoading = false;
      guest = GuestModel(guestName: "WeWed", guestProfileImage: "", feeds: []);
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      guest = GuestModel(guestName: "WeWed", guestProfileImage: "", feeds: []);

      if (kDebugMode) {
        log("login error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
