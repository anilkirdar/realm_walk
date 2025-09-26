import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../../../product/enum/local_keys_enum.dart';
import '../../constants/app/app_const.dart';
import '../../constants/network/api_const.dart';
import '../cache/local_manager.dart';
import '../firebase/crashlytics/crashlytics_manager.dart';

class UploadManager {
  static UploadManager? _instance;
  late Dio dio;
  String _token = LocalManager.instance.getStringValue(LocalManagerKeys.token);
  CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  CrashlyticsMessages crashlyticsMessage = CrashlyticsMessages.instance;

  static UploadManager get instance {
    return _instance ??= UploadManager._init();
  }

  UploadManager._init() {
    dio = _getManager(token: _token);
  }

  Dio _getManager({required String token}) {
    final bool isStagingServer =
        LocalManager.instance.getBoolValue(LocalManagerKeys.isStagingServer) ??
        false;

    return Dio(
      BaseOptions(
        baseUrl: isStagingServer ? APIConst.baseStagingUrl : APIConst.baseUrl,
        headers: headersAppJson(token),
      ),
    );
  }

  void updateToken(String token) {
    _token = token;
    dio = _getManager(token: token);
  }

  void clearHeader() {
    dio.interceptors.clear();
    _token = '';
    dio = _getManager(token: '');
  }

  Future<Response> uploadImage({
    required String apiPath,
    required String apiKey,
    required XFile image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        apiKey: await MultipartFile.fromFile(
          image.path,
          filename: image.name.split('.')[0],
          contentType: MediaType(
            lookupMimeType(getFileName(image.path))!.split('/')[0],
            lookupMimeType(getFileName(image.path))!.split('/')[1],
          ),
        ),
      });
      Response<dynamic> response = await dio.put(
        apiPath,
        data: formData,
        onSendProgress: (int sent, int total) {},
      );
      return response;
    } catch (e) {
      crashlyticsManager.sendACrash(
        error: e,
        stackTrace: StackTrace.current,
        reason: "Error uploadImage",
      );
      rethrow;
    }
  }

  String getFileName(String pathString) {
    return path.basename(pathString);
  }

  Map<String, String> headersAppJson(String token) {
    return {
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer $token',
    };
  }
}
