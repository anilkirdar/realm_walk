import 'package:vexana/vexana.dart';

abstract class IPerformanceService<E extends INetworkModel<E>?> {
  /// Get if performance monitoring is enabled;
  bool get isMonitoringEnabled;

  /// Set if performance monitoring is enabled or not;
  Future<void> setIsMonitoringEnabled(bool value);

  Future<IResponseModel<dynamic, INetworkModel?>>
      networkMeter<T extends INetworkModel<T>, R>(
    String traceName,
    INetworkManager manager, {
    required String path,
    required T parseModel,
    required RequestType method,
  });

  Future<T?> traceWithOneArgument<T, P1>({
    required String functionName,
    required Future<T?> Function(P1) function,
    required P1 argument,
  });

  Future<T?> traceWithTwoArguments<T, P1, P2>({
    required String functionName,
    required Future<T?> Function(P1 p1, P2 p2) function,
    required P1 argument,
    required P2 argument2,
  });
}
