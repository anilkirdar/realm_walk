import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static PermissionManager? _instance;

  static PermissionManager get instance {
    return _instance ??= PermissionManager._init();
  }

  PermissionManager._init();

  bool _isPermissionBeingRequested = false;

  Future<bool> _getPermission(
      {required Permission permission,
      Future<Function()>? onPermanentlyDenied}) async {
    ///Returns true while debugging on web
    if (kIsWeb && kDebugMode) {
      return true;
    }
    PermissionStatus status = await permission.status;
    if (status.isDenied ||
        status.isRestricted ||
        status.isLimited ||
        status.isPermanentlyDenied) {
      if (_isPermissionBeingRequested) return false;
      _isPermissionBeingRequested = true;

      await permission.request();
      status = await permission.status;

      _isPermissionBeingRequested = false;
    }
    if (status.isDenied ||
        status.isRestricted ||
        status.isLimited ||
        status.isPermanentlyDenied) {
      await onPermanentlyDenied;
      return false;
    }
    return true;
  }

  Future<bool> getCameraPermission() async {
    final bool isGranted = await _getPermission(permission: Permission.camera);
    return isGranted;
  }

  Future<bool> getMicrophonePermission() async {
    final bool isGranted =
        await _getPermission(permission: Permission.microphone);
    return isGranted;
  }

  Future<bool> getMicrophoneStatus() async {
    final PermissionStatus permissionStatus =
    await Permission.microphone.status;
    return permissionStatus.isGranted;
  }

  Future<bool> getNotificationPermission() async {
    final bool isGranted =
        await _getPermission(permission: Permission.notification);
    return isGranted;
  }

  Future<bool> getNotificationStatus() async {
    final PermissionStatus permissionStatus =
        await Permission.notification.status;
    return permissionStatus.isGranted;
  }

  Future<bool> getAppTransparencyPermission() async {
    final PermissionStatus permissionStatus =
        await Permission.appTrackingTransparency.request();
    return permissionStatus.isGranted;
  }

  Future<bool> getAppTransparencyStatus() async {
    final PermissionStatus permissionStatus =
        await Permission.appTrackingTransparency.status;
    return permissionStatus.isGranted;
  }

  Future<bool> getPhotosPermission() async {
    final bool isGranted = await _getPermission(permission: Permission.photos);
    return isGranted;
  }

  Future<bool> getVideosPermission() async {
    final bool isGranted = await _getPermission(permission: Permission.videos);
    return isGranted;
  }
}
