import '../../../base/model/base_model.dart';
import '../../../constants/enums/http_request_enum.dart';
import 'i_response_model.dart';

abstract class ICoreDioNullSafety {
  Future<IResponseModel<R>> send<R, T>(
    String path, {
    required HttpTypes type,
    required BaseModel<T> parseModel,
    dynamic data,
    Map<String, Object>? queryParameters,
    void Function(int, int)? onReceiveProgress,
  });
}
// // MARK: Null Safety
// abstract class ICoreDioFullNulSafetyFull extends ICoreDioNullSafety {
//   Future<IResponseModel<R>> fetchNoNetwork<R, T extends BaseModel>(
//     String path, {
//     required HttpTypes type,
//     required T parseModel,
//     dynamic data,
//     Map<String, Object>? queryParameters,
//     void Function(int, int)? onReceiveProgress,
//   });
// }
