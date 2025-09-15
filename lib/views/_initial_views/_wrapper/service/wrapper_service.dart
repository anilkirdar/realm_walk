import 'dart:io';

import 'package:vexana/vexana.dart';

import '../../../../core/base/service/base_service.dart';
import '../../../../core/constants/network/api_const.dart';
import '../../../../core/init/cache/local_manager.dart';
import '../../../../core/init/network/model/error_model_custom.dart';
import '../../../../product/enum/local_keys_enum.dart';
import '../model/check_services_model.dart';
import '../model/fetched_initial_result.dart';
import '../model/send_fcm_model.dart';
import 'i_wrapper_service.dart';

enum _TestingAPI {
  testing(apiPath: '/testing');

  const _TestingAPI({required this.apiPath});

  final String apiPath;
}

class WrapperService extends IWrapperService with BaseService {
  WrapperService({
    required INetworkManager<ErrorModelCustom> manager,
    required INetworkManager<EmptyModel> linqiAppComManager,
    required INetworkManager<EmptyModel> googleComManager,
  }) : super(manager, linqiAppComManager, googleComManager);

  get baseUrl =>
      LocalManager.instance.getBoolValue(LocalManagerKeys.isStagingServer) ??
              false
          ? "https://${APIConst.baseStagingUrl}"
          : "https://${APIConst.baseUrl}";

  get dio => Dio(BaseOptions(baseUrl: baseUrl, headers: {
        "Authorization":
            "Bearer ${LocalManager.instance.getStringValue(LocalManagerKeys.token)}",
      }));

  @override
  Future<FetchedInitialResult?> sendFCMAndCheckIsPremium(
      SendFCMTokenModel fcmToken) async {
    try {
      final result =
          await manager.send<FetchedInitialResult, FetchedInitialResult>(
        APIConst.userInit,
        parseModel: FetchedInitialResult(),
        method: RequestType.POST,
        data: fcmToken.toJson(),
      );

      if (result.error != null) {
        final errorMessage =
            (result.error?.model?.toJson() ?? {})['message'] ?? '';

        if (errorMessage == 'ACCOUNT_SUSPENDED') {
          return FetchedInitialResult(
            isAccountSuspended: true,
          );
        }
      }

      if (result.data is FetchedInitialResult) {
        return result.data;
      }
      return null;
    } catch (e) {
      await crashlyticsManager.sendACrash(
          error: e.toString(),
          stackTrace: StackTrace.current,
          reason: 'sendFCMAndCheckIsPremium error');
      return null;
    }
  }

  @override
  Future<CheckServicesModel> checkServices() async {
    /// Sending a get request to google.com/test to get error of 404.
    /// If 404 is returned, it means that the internet is working.
    final linqiResult =
        await linqiAppComManager.send<CheckServicesModel, CheckServicesModel>(
            _TestingAPI.testing.apiPath,
            parseModel: CheckServicesModel(),
            method: RequestType.GET);

    /// Sending a get request to google.com/test to get error of 404.
    /// If 404 is returned, it means that the internet is working.
    final googleResult =
        await googleComManager.send<CheckServicesModel, CheckServicesModel>(
            _TestingAPI.testing.apiPath,
            parseModel: CheckServicesModel(),
            method: RequestType.GET);

    return CheckServicesModel(
        isGoogleComEnabled:
            googleResult.error?.statusCode == HttpStatus.notFound,
        isLinqiAppComEnabled:
            linqiResult.error?.statusCode == HttpStatus.notFound,
        googleComMessage: 'statusCode ${googleResult.error?.statusCode}, '
            'description ${googleResult.error?.description}',
        linqiAppMessage: 'statusCode ${linqiResult.error?.statusCode}. '
            'description ${linqiResult.error?.description}');
  }
}
