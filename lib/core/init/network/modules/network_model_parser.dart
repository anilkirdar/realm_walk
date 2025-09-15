import 'package:vexana/vexana.dart';

import '../../print_dev.dart';

class ModelParser {
  static R? parseBody<R, T extends INetworkModel>(
      {required dynamic responseBody, required T model}) {
    try {
      if (responseBody is List) {
        return responseBody
            .map((data) => model.fromJson(data))
            .cast<T>()
            .toList() as R;
      } else if (responseBody is Map<String, dynamic>) {
        return model.fromJson(responseBody) as R;
      } else {
        if (R is EmptyModel || R == EmptyModel) {
          return EmptyModel(name: responseBody.toString()) as R;
        } else {
          PrintDev.instance.debug(
              'Be careful your data $responseBody, I could not parse it');
          return null;
        }
      }
    } catch (e) {
      PrintDev.instance.exception(
          'Parse Error: $e - response body: $responseBody T model: $T , R model: $R ');
    }
    return null;
  }
}
