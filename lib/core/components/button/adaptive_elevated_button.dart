import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/config/config.dart';
import '../../init/notifier/theme_notifier.dart';

/// TODO: there is an issue with android padding. Make tests in ui after
/// TODO: removing setZeroPaddingForAndroid
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onPressed,
    this.borderRadius,
    this.height,
    this.setZeroPaddingForAndroid,
    this.padding,
    this.buttonElevation,
  });
  final Function()? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final double? height;
  final EdgeInsets? padding;
  final bool? setZeroPaddingForAndroid;
  final double? buttonElevation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Config.instance.isAndroid
              ? ElevatedButton(
                  onPressed: onPressed,
                  style: androidStyle(context),
                  child: SizedBox(
                    height: 28,
                    child: child,
                  ))
              : ClipRRect(
                  borderRadius: borderRadius ?? RadiusConst.elevatedButton,
                  child: Container(
                    color: context.theme.scaffoldBackgroundColor,
                    constraints: BoxConstraints(
                      minHeight: height ?? SizeConst.elevatedButtonMediumHeight,
                      maxHeight: height ?? SizeConst.elevatedButtonMediumHeight,
                    ),
                    child: CupertinoButton(
                      onPressed: onPressed,
                      color:
                          backgroundColor ?? context.theme.colorScheme.primary,
                      borderRadius: borderRadius ?? RadiusConst.elevatedButton,
                      padding: EdgeInsets.zero,
                      disabledColor: Provider.of<ThemeNotifier>(context)
                          .getCustomTheme
                          .lightGreyToWhite,
                      pressedOpacity: 0.8,
                      child: SizedBox(
                        height: 28,
                        child: Theme(
                          data: Provider.of<ThemeNotifier>(context).getTheme,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  ButtonStyle androidStyle(BuildContext context) {
    return context.theme.elevatedButtonTheme.style!.copyWith(
        elevation: buttonElevation != null
            ? MaterialStateProperty.all(buttonElevation!)
            : null,

        ///TODO: SET HEIGHT elevatedButtonMinHeight
        padding: (setZeroPaddingForAndroid ?? false)
            ? const MaterialStatePropertyAll(EdgeInsets.zero)
            : MaterialStatePropertyAll(padding),
        minimumSize: MaterialStatePropertyAll(Size(
            SizeConst.elevatedButtonMinWidth,
            height ?? SizeConst.elevatedButtonMediumHeight)),
        maximumSize: MaterialStatePropertyAll(Size(
            SizeConst.elevatedButtonMinWidth,
            height ?? SizeConst.elevatedButtonMaxHeight)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Provider.of<ThemeNotifier>(context)
                  .getCustomTheme
                  .lightGreyToWhite; // Devre dışı renge istediğiniz rengi burada ayarlayabilirsiniz.
            }
            return backgroundColor ??
                Color(0xFF6962CF); // Normal durumda butonun rengi
          },
        ),
        shape: borderRadius != null
            ? MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: borderRadius!))
            : context.theme.elevatedButtonTheme.style!.shape);
  }
}
