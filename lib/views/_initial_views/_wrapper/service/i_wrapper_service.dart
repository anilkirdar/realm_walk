import 'package:vexana/vexana.dart';

import '../../../../core/init/network/model/error_model_custom.dart';
import '../model/check_services_model.dart';

abstract class IWrapperService {
  IWrapperService(this.manager, this.googleComManager);

  final INetworkManager<ErrorModelCustom> manager;

  final INetworkManager<EmptyModel> googleComManager;

  Future<CheckServicesModel> checkServices();
}
