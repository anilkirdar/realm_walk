import 'package:vexana/vexana.dart';

import '../../../../core/init/network/model/error_model_custom.dart';
import '../model/check_services_model.dart';
import '../model/fetched_initial_result.dart';
import '../model/send_fcm_model.dart';

abstract class IWrapperService {
  IWrapperService(this.manager, this.linqiAppComManager, this.googleComManager);

  final INetworkManager<ErrorModelCustom> manager;

  final INetworkManager<EmptyModel> linqiAppComManager;

  final INetworkManager<EmptyModel> googleComManager;

  Future<FetchedInitialResult?> sendFCMAndCheckIsPremium(
      SendFCMTokenModel fcmToken);

  Future<CheckServicesModel> checkServices();
}
