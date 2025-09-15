import '../constants/enums/http_request_enum.dart';

extension NetworkTypeExtension on HttpTypes {
  String get rawValue {
    switch (this) {
      case HttpTypes.get:
        return 'GET';
      case HttpTypes.post:
        return 'POST';
      case HttpTypes.delete:
        return 'DELETE';
      case HttpTypes.put:
        return 'PUT';
      // ignore: unreachable_switch_default
      default:
        throw 'Error type';
    }
  }
}
