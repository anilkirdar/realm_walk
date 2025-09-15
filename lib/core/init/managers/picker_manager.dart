import 'package:image_picker/image_picker.dart';

import 'permission_manager.dart';

class PickerManager {
  static PickerManager? _instance;

  static PickerManager get instance {
    return _instance ??= PickerManager._init();
  }

  PickerManager._init();

  Future<XFile?> pickImage({
    required bool isCamera,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    int? imageQuality = 100,
    double? maxWidth = 1080,
  }) async {
    try {
      PermissionManager permissionManager = PermissionManager.instance;

      ///Get permission if it is not granted
      final bool hasCameraAccess =
          await permissionManager.getCameraPermission();

      if (hasCameraAccess == false) {
        return null;
      }

      final XFile? pickedImageFile = await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        preferredCameraDevice: preferredCameraDevice,
      );

      if (pickedImageFile == null) return null;

      return pickedImageFile;
    } catch (e) {
      print('Error at pickImage in pickerManager: $e');
      // await CrashlyticsManager.instance.sendACrash(
      //     error: e.toString(),
      //     stackTrace: StackTrace.current,
      //     reason: 'Error at pickImage in pickerManager',
      //     isFatal: true);
    }
    return null;
  }
}
