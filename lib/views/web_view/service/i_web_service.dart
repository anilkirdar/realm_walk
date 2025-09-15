import 'package:vexana/vexana.dart';

abstract class IWebService {
  IWebService(this.manager);

  final INetworkManager manager;
}
