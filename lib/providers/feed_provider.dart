import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wedding/general/shared_preferences.dart';
import 'package:wedding/general/string_constants.dart';
import 'package:wedding/models/comment_model.dart';
import 'package:wedding/models/feed_model.dart';
import 'package:wedding/models/response_model.dart';
import 'package:wedding/providers/user_provider.dart';

import '../main.dart';

class FeedProvider with ChangeNotifier {
  bool isFeedLoaded = false;
  bool isCommentLoading = false;
  bool isUploading = false;
  List<FeedModel> feeds = [];
  List<CommentModel> feedCommentList = [];

  Future<ResponseClass<List<FeedModel>>> getFeed(int page) async {
    String url = StringConstants.apiUrl + StringConstants.viewFeed;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    var data = {
      "marriage_id": marriageId,
      "guest_id": sharedPrefs.guestId,
      "page": page,
      "limit": 10
    };

    //Response
    ResponseClass<List<FeedModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: feeds);
    try {
      Response response =
          await dio.get(url, queryParameters: data, options: Options(
        validateStatus: (status) {
          return status == 200 || status == 400;
        },
      ));
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        List feedList = response.data["data"];
        if (response.data["pagination"] != null) {
          Pagination pagination =
          Pagination.fromJson(response.data["pagination"]);
          responseClass.pagination = pagination;
        }
        List<FeedModel> list =
            feedList.map((e) => FeedModel.fromJson(e)).toList();
        responseClass.data = list;
        feeds = list;
        if (page == 1) {
          feeds = list;
        } else {
          feeds.addAll(list);
        }
        isFeedLoaded = true;
        notifyListeners();
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.data["message"]);
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isFeedLoaded = true;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isFeedLoaded = true;
      notifyListeners();
      if (kDebugMode) {
        log("feed error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<List<CommentModel>>> getFeedComment(
      {required String feedId}) async {
    String url =
        StringConstants.apiUrl + StringConstants.viewFeedComment + '/$feedId';
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //Response
    ResponseClass<List<CommentModel>> responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: feedCommentList);
    try {
      isCommentLoading = true;
      notifyListeners();
      Response response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        List tempCommentList = response.data["data"];
        List<CommentModel> list =
            tempCommentList.map((e) => CommentModel.fromJson(e)).toList();
        responseClass.data = list;
        feedCommentList = list;
        isCommentLoading = false;
        notifyListeners();
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.data["message"]);
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isCommentLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isCommentLoading = false;
      notifyListeners();
      if (kDebugMode) {
        log("feed error ->" + e.toString());
      }
      return responseClass;
    }
  }

  Future<ResponseClass<int>> updateLikeComment(
      Map<String, dynamic> data) async {
    String url = StringConstants.apiUrl + StringConstants.updateFeedLikeComment;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    //Response
    ResponseClass<int> responseClass =
        ResponseClass(success: false, message: "Something went wrong", data: 0);
    try {
      Response response = await dio.patch(url, data: data, options: Options(
        validateStatus: (status) {
          return status == 200 || status == 400;
        },
      ));
      if (response.statusCode == 200) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        notifyListeners();
      }
      if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: response.data["message"]);
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      notifyListeners();
      Fluttertoast.showToast(msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      notifyListeners();
      if (kDebugMode) {
        log("feed error ->" + e.toString());
      }
      return responseClass;
    }
  }

  updateCommentList(var comment) {
    feedCommentList.add(CommentModel(
        guestProfileImage: sharedPrefs.guestProfileImage,
        guestName: sharedPrefs.guestName,
        guestId: sharedPrefs.guestId,
        commentText: comment,
        time: DateTime.now()));
    notifyListeners();
  }

  Future<ResponseClass> addFeed({required FormData formData}) async {
    String url = StringConstants.apiUrl + StringConstants.addFeed;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    formData.fields
        .add(MapEntry("marriage_id", marriageId));
    formData.fields.add(MapEntry("guest_id", sharedPrefs.guestId));
    //body Data
    var data = formData;

    //Response
    ResponseClass responseClass = ResponseClass(
        success: false, message: "Something went wrong", data: {});
    try {
      isUploading = true;
      notifyListeners();
      Response response = await dio.post(url, data: data, options: Options(
        validateStatus: (status) {
          return status == 201;
        },
      ));
      if (response.statusCode == 201) {
        responseClass.success = response.data["is_success"];
        responseClass.message = response.data["message"];
        responseClass.data = response.data["data"];
        isUploading = false;
        notifyListeners();
      }
      return responseClass;
    } on DioError catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      isUploading = false;
      notifyListeners();
      Fluttertoast.showToast(
          msg: StringConstants.errorMessage);
      return responseClass;
    } catch (e) {
      isUploading = false;
      notifyListeners();
        log("add feed error ->" + e.toString());
      return responseClass;
    }
  }
}
