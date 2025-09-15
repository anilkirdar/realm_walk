import 'package:vexana/vexana.dart';

abstract class IMainService {
  IMainService(this.manager);

  final INetworkManager manager;
}
