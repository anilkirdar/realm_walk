import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../components/toast/toast.dart';
import '../../print_dev.dart';

export '../../../constants/utils/text_constants/crashlytics_message.dart';

class CrashlyticsManager {
  static CrashlyticsManager? _instance;

  static CrashlyticsManager get instance {
    return _instance ??= CrashlyticsManager._init();
  }

  bool _isStagingServer = false;

  void setIsStagingServer(bool value) {
    _isStagingServer = value;
  }

  CrashlyticsManager._init();

  Future<void> sendACrash({
    required dynamic error,
    String? statusCode,
    required StackTrace stackTrace,
    required String reason,
    bool isFatal = false,
  }) async {
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: _isStagingServer ? 'STAGING SERVER: $reason' : reason,
        fatal: isFatal,
      );
    } else {
      flutterInfoToast(reason);
      PrintDev.instance.exception(
          '________________________________ERROR________________________________');
      PrintDev.instance.exception('response.error:\n$error');
      PrintDev.instance.exception('reason:$reason');
      flutterErrorToast("DEBUG: ${error.toString()}");
      PrintDev.instance.exception(
          '||______________________________ERROR______________________________||');
    }
    return;
  }
}
