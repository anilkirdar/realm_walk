import '../../network/model/error_model_custom.dart';
import 'i_performance_service.dart';
import 'performance_service.dart';

class PerformanceManager {
  static PerformanceManager? _instance;

  static PerformanceManager get instance {
    return _instance ??= PerformanceManager._init();
  }

  PerformanceManager._init();

  IPerformanceService<ErrorModelCustom> networkManager = PerformanceService();
}
