import 'package:firebase_performance/firebase_performance.dart';
import 'package:vexana/vexana.dart';

import '../crashlytics/crashlytics_manager.dart';
import 'i_performance_service.dart';

class PerformanceService<E extends INetworkModel<E>?>
    implements IPerformanceService<E> {
  PerformanceService();

  final FirebasePerformance _performance = FirebasePerformance.instance;

  final CrashlyticsManager _crashlyticsManager = CrashlyticsManager.instance;

  bool _isMonitoringEnabled = false;

  @override
  bool get isMonitoringEnabled => _isMonitoringEnabled;

  @override
  Future<void> setIsMonitoringEnabled(bool value) async {
    await _performance.setPerformanceCollectionEnabled(value);
    _isMonitoringEnabled = value;
  }

  @override
  Future<IResponseModel<dynamic, INetworkModel?>>
      networkMeter<T extends INetworkModel<T>, R>(
    String traceName,
    INetworkManager manager, {
    required String path,
    required T parseModel,
    required RequestType method,
  }) async {
    Trace trace = _performance.newTrace(traceName);

    if (_isMonitoringEnabled) await trace.start();

    final result =
        await manager.send<T, R>(path, parseModel: parseModel, method: method);

    if (_isMonitoringEnabled) await trace.stop();

    return result;
  }

  @override
  Future<T?> traceWithOneArgument<T, P1>({
    required String functionName,
    required Future<T?> Function(P1) function,
    required P1 argument,
  }) async {
    Trace trace = _performance.newTrace(functionName);
    T? result;

    try {
      /// Start the trace
      await trace.start();

      /// Execute the function with the provided argument and store the result
      result = await function(argument);
    } catch (error, stackTrace) {
      _crashlyticsManager.sendACrash(
        error: error,
        stackTrace: stackTrace,
        reason: 'error in traceFunctionPerformance. functionName:$functionName',
      );

      return null;
    } finally {
      /// Stop the trace
      await trace.stop();
    }

    /// Return the result from the traced function
    return result;
  }

  @override
  Future<T?> traceWithTwoArguments<T, P1, P2>({
    required String functionName,
    required Future<T?> Function(P1 p1, P2 p2) function,
    required P1 argument,
    required P2 argument2,
  }) async {
    Trace trace = _performance.newTrace(functionName);
    T? result;

    try {
      /// Start the trace
      await trace.start();

      /// Execute the function with the provided argument and store the result
      result = await function(argument, argument2);
    } catch (error, stackTrace) {
      _crashlyticsManager.sendACrash(
        error: error,
        stackTrace: stackTrace,
        reason: 'error in traceFunctionPerformance. functionName:$functionName',
      );

      return null;
    } finally {
      /// Stop the trace
      await trace.stop();
    }

    /// Return the result from the traced function
    return result;
  }
}
