import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/notifier/theme_notifier.dart';
import '../../init/theme/app_color_scheme.dart';

class AdaptiveCPI extends StatelessWidget {
  const AdaptiveCPI({
    super.key,
    this.strokeWidth,
    this.backgroundColor,
    this.value,
    this.size,
  });
  final double? strokeWidth, value;
  final Color? backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Platform.isIOS
              ? CupertinoActivityIndicator(
                color:
                    backgroundColor ??
                    Provider.of<ThemeNotifier>(
                      context,
                    ).getCustomTheme.blackToWhite,
                radius: size ?? 10,
              )
              : CircularProgressIndicator(
                value: value,
                strokeWidth:
                    strokeWidth ?? SizeConst.circularProgressIndicatorWidth,
                backgroundColor:
                    backgroundColor ?? AppColorScheme.instance.white,
              ),
    );
  }
}
