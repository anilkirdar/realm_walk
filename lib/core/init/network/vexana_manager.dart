import 'package:flutter/foundation.dart';
import 'package:vexana/vexana.dart';

import '../../../product/enum/local_keys_enum.dart';
import '../../constants/network/api_const.dart';
import '../cache/local_manager.dart';
import './model/error_model_custom.dart';

class VexanaManager {
  static VexanaManager? _instance;
  late INetworkManager<ErrorModelCustom> networkManager;
  late String networkManagerConnectivity;

  INetworkManager<EmptyModel> linqiAppComManager = NetworkManager<EmptyModel>(
      options: BaseOptions(baseUrl: APIConst.linqiAppMain));

  NetworkManager<EmptyModel> googleComManager = NetworkManager<EmptyModel>(
      options: BaseOptions(baseUrl: APIConst.googleCom));

  //late Stream<ConnectivityResult> connectivityStream;

  static VexanaManager get instance {
    if (LocalManager.instance.getStringValue(LocalManagerKeys.token) == '') {
      _instance?.clearHeader();
    }
    return _instance ??= VexanaManager._init();
  }

  static String _token =
      LocalManager.instance.getStringValue(LocalManagerKeys.token);

  VexanaManager._init() {
    networkManager = _getManager(token: _token);
    // connectivityStream = Connectivity().onConnectivityChanged;
  }

  void clearHeader() {
    networkManager.clearHeader();
    _token = '';
    networkManager = _getManager(token: '', isCleaned: true);
  }

  void addToken(String token) {
    networkManager = _getManager(token: token);
  }

  NetworkManager<ErrorModelCustom> _getManager(
      {required String token, bool isCleaned = false}) {
    final bool isStagingServer =
        LocalManager.instance.getBoolValue(LocalManagerKeys.isStagingServer) ??
            false;
    return NetworkManager<ErrorModelCustom>(
        errorModel: ErrorModelCustom(),
        isEnableLogger: kDebugMode ? false : false,

        //noNetwork: context != null ? NoNetwork(context) : null,
        options: BaseOptions(
            baseUrl:
                "https://${isStagingServer ? APIConst.baseStagingUrl : APIConst.baseUrl}",
            headers: isCleaned ? jsonHeader : headersAppJson(token)));
  }

  // INetworkManager<ErrorModelCustom> managerWithOfflineSupport(
  //     BuildContext context) {
  //   return _getManager(token: _token, context: context);
  // }

  Map<String, String> headersAppJson(String token) {
    return {
      "Content-type": "application/json",
      'Authorization': 'Bearer $token'
    };
  }

  Map<String, String> get jsonHeader {
    return {"Content-type": "application/json"};
  }
}
