import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:vexana/vexana.dart';

import '../../../product/enum/local_keys_enum.dart';
import '../../constants/network/api_const.dart';
import '../cache/local_manager.dart';
import './model/error_model_custom.dart';

class VexanaManager {
  static VexanaManager? _instance;
  static VexanaManager get instance {
    return _instance ??= VexanaManager._init();
  }

  late INetworkManager<ErrorModelCustom> networkManager;
  NetworkManager<EmptyModel> googleComManager = NetworkManager<EmptyModel>(
    options: BaseOptions(baseUrl: APIConst.googleCom),
  );

  late String networkManagerConnectivity;
  late Stream<ConnectivityResult> connectivityStream;

  static String _token = LocalManager.instance.getStringValue(
    LocalManagerKeys.token,
  );

  VexanaManager._init() {
    networkManager = _getManager(token: _token);
    connectivityStream = Connectivity().onConnectivityChanged;
  }

  void clearHeader() {
    networkManager.clearHeader();
    _token = '';
    networkManager = _getManager(token: '', isCleaned: true);
  }

  void addToken(String token) {
    networkManager = _getManager(token: token);
  }

  NetworkManager<ErrorModelCustom> _getManager({
    required String token,
    bool isCleaned = false,
  }) {
    final bool isStagingServer =
        LocalManager.instance.getBoolValue(LocalManagerKeys.isStagingServer) ??
        false;
    return NetworkManager<ErrorModelCustom>(
      errorModel: ErrorModelCustom(),
      isEnableLogger: kDebugMode ? true : false,
      options: BaseOptions(
        baseUrl: isStagingServer ? APIConst.baseStagingUrl : APIConst.apiUrl,
        // headers: jsonHeader,
        headers: isCleaned ? jsonHeader : headersAppJson(token),
        extra: {"withCredentials": false},
      ),
    );
  }

  Map<String, String> headersAppJson(String token) {
    return {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, String> get jsonHeader {
    return {"Content-type": "application/json"};
  }
}
