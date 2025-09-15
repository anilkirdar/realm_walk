import 'i_error_model.dart';

abstract class IResponseModel<T> {
  T? data;
  IErrorModel? error;
}
