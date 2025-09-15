import '../../init/network/interface/i_error_model.dart';

class BaseError<T> extends IErrorModel {
// class BaseError<T> extends IErrorModel<T> {
  BaseError(this.message);
  final String message;
}
