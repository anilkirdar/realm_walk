import '../../init/firebase/crashlytics/crashlytics_manager.dart';
import '../../init/firebase/performance/performance_manager.dart';
import '../../init/print_dev.dart';

abstract mixin class BaseService {
  final CrashlyticsManager crashlyticsManager = CrashlyticsManager.instance;

  final CrashlyticsMessages crashlyticsMessage = CrashlyticsMessages.instance;

  final PerformanceManager performanceManager = PerformanceManager.instance;

  final PrintDev printDev = PrintDev.instance;
}