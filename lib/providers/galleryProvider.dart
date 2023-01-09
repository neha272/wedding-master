import 'dart:developer';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class GalleryProvider with ChangeNotifier {
  bool isLoaded = false;
  List galleryData = [];

  Future<ResponseClass<List>> getGallery(
      {required String eventId, required int page}) async {
    String url = StringConstants.apiUrl + StringConstants.getAllGallery;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //Response
    ResponseClass<List> responseClass =
        ResponseClass(success: false, message: "Something went wrong");
    try {
      Response response = await dio.get(url, queryParameters: {
        "marriage_id": marriageId,
        "event_id": eventId,
        "page": page,
        "limit": 15
      });
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
              Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List galleryList = response.data["data"];
        galleryData = galleryList;
        responseClass.data = galleryList;
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
        log("gallery error ->" + e.toString());
      }
      return responseClass;
    }
  }
}
