import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/assets/image_const.dart';
import '../../../constants/utils/ui_constants/padding_const.dart';
import '../../../constants/utils/ui_constants/radius_const.dart';
import '../../../constants/utils/ui_constants/size_const.dart';
import '../../../init/notifier/theme_notifier.dart';
import '../../../init/theme/app_color_scheme.dart';
import 'base_network_image.dart';

///TODO: improve size management
class IconAvatarWidget extends StatelessWidget {
  const IconAvatarWidget({
    super.key,
    required this.image,
    required this.isMedium,
    this.borderWidth = 0,
    this.borderColor,
    this.errorPadding,
    this.errorImage,
    this.size,
    this.shadow,
  });

  final String image;
  final bool? isMedium;
  final double borderWidth;
  final Color? borderColor;
  final EdgeInsets? errorPadding;
  final String? errorImage;
  final double? size;
  final bool? shadow;

  @override
  Widget build(BuildContext context) {
    final double width = SizeConst.getImageSize(isMedium) + borderWidth;
    final BorderRadius borderRadius = RadiusConst.getImageRadius(isMedium);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToGrey,
        ),
      ),
      child: Container(
        /// width is provided to height, because we need a square image
        width: size ?? width,
        height: size ?? width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color:
                borderColor ??
                Provider.of<ThemeNotifier>(
                  context,
                ).getCustomTheme.lightGreyToDarkerGrey,
            width: borderWidth,
          ),
          boxShadow:
              shadow == true
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Container(
            decoration: BoxDecoration(color: AppColorScheme.instance.white),
            child: BaseNetworkImage(
              image,
              fit: BoxFit.cover,
              width: width,
              height: SizeConst.imageSmall,
              errorPadding: errorPadding ?? PaddingConst.all30,
              errorImage: errorImage ?? ImageConst.instance.userPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
