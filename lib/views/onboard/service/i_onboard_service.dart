import 'package:vexana/vexana.dart';

import '../../../core/init/firebase/crashlytics/crashlytics_manager.dart';
import '../../../core/init/network/model/error_model_custom.dart';

/// Returned types in all requests are success value
abstract class IOnboardService {
  IOnboardService(this.manager);

  final INetworkManager<ErrorModelCustom> manager;

  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;
  final CrashlyticsMessages crashlyticsMessage = CrashlyticsMessages.instance;
}
