import 'package:flutter/cupertino.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/radius_const.dart';
import '../../constants/utils/ui_constants/sized_box_const.dart';
import '../../init/theme/app_color_scheme.dart';
import '../icons/svg_icon.dart';

class CircularIconTextButton extends StatelessWidget {
  const CircularIconTextButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
    required this.subText,
    required this.isEnabled,
    this.radius,
    this.iconBackgroundColor,
    this.iconColor,
    this.iconSize,
    this.disabledIconPath,
    this.disabledIconColor,
    this.disabledSubText,
    this.shouldSetColor = true,
    this.textAlign,
    this.size = 60,
    this.width = 80,
  })  : assert(disabledIconPath != null || isEnabled,
            "It can't have disabledPath null and isEnabled false"),
        assert(disabledSubText != null || isEnabled,
            "It can't have disabledSubText null and isEnabled false");
  final double size, width;
  final double? radius, iconSize;
  final Color? iconBackgroundColor, iconColor, disabledIconColor;
  final String iconPath, subText;
  final String? disabledIconPath, disabledSubText;
  final Function() onPressed;
  final bool isEnabled, shouldSetColor;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConst.horizontal12,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                borderRadius: RadiusConst.circular75,
                border: Border.all(
                  color: isEnabled
                      ? iconBackgroundColor ?? AppColorScheme.instance.success
                      : AppColorScheme.instance.white,
                  width: 3,
                ),
                color: isEnabled
                    ? (iconBackgroundColor ??
                        context.theme.scaffoldBackgroundColor)
                    : AppColorScheme.instance.white,
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                child: SizedBox(
                  child: SvgPictureAsset(
                    asset: isEnabled == false ? disabledIconPath! : iconPath,
                    color: isEnabled
                        ? iconColor
                        : disabledIconColor ??
                            AppColorScheme.instance.secondary,
                    height: iconSize ?? 28,
                    shouldSetColor: shouldSetColor,
                    width: iconSize ?? 28,
                  ),
                ),
              ),
            ),
            SizedBoxConst.height4,
            Text(
              isEnabled ? subText : disabledSubText!,
              textAlign: textAlign,
              style: context.textTheme.titleMedium!
                  .copyWith(color: AppColorScheme.instance.white),
            )
          ],
        ),
      ),
    );
  }
}
