import 'package:flutter/material.dart';

import '../config/config.dart';

class ScrollManager {
  static ScrollManager? _instance;

  static ScrollManager get instance {
    return _instance ??= ScrollManager._init();
  }

  ScrollBehavior get nonOverScrollingBehaviorAndroid {
    return const ScrollBehavior().copyWith(
        overscroll: Config.instance.isAndroid ? false : true,
        physics:
            Config.instance.isAndroid ? null : const BouncingScrollPhysics());
  }

  ScrollBehavior get nonOverScrollingBehavior {
    return const ScrollBehavior().copyWith(overscroll: false);
  }

  ScrollManager._init();
}
