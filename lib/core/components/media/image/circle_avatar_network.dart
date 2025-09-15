import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extension.dart';
import '../../../constants/assets/svg_const.dart';
import '../../../constants/utils/decorations/box_decoration.dart';
import '../../../constants/utils/ui_constants/radius_const.dart';
import '../../../constants/utils/ui_constants/size_const.dart';
import '../../../init/theme/app_color_scheme.dart';
import '../../icons/svg_icon.dart';
import 'base_network_image.dart';

class CircleAvatarNetwork extends StatelessWidget {
  const CircleAvatarNetwork({
    super.key,
    required this.imageUrl,
    this.placeHolder,
    this.isMedium,
    this.boxfit,
    this.size,
    this.placeHolderColor,
    this.placeHolderPadding,
    this.hasBorder = false,
    this.backgroundColor,
    this.errorImage,
    this.errorPadding,
    this.boxDecoration,
  });
  final String imageUrl;
  final String? errorImage;
  final bool? isMedium;
  final bool hasBorder;
  final BoxFit? boxfit;
  final double? size, placeHolderPadding;
  final Widget? placeHolder;
  final Color? placeHolderColor, backgroundColor;
  final EdgeInsets? errorPadding;
  final BoxDecoration? boxDecoration;

  @override
  Widget build(BuildContext context) {
    final double width = size ?? SizeConst.getUserImageSize(isMedium);
    return Container(
      height: width,
      width: width,
      decoration: hasBorder
          ? (boxDecoration ??
              BoxDecorationConst.instance.userAvatar(context.theme))
          :  BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorScheme.instance.white,
            ),
      child: ClipRRect(
        borderRadius:
            width > 50 ? RadiusConst.circular75 : RadiusConst.circular50,
        child: BaseNetworkImage(
          imageUrl,
          errorImage: errorImage,
          errorPadding: errorPadding,
          fit: boxfit ?? BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class UserPlaceholder extends StatelessWidget {
  const UserPlaceholder({
    super.key,
    required this.width,
    required this.placeHolderColor,
    this.hasBorder = true,
    this.backgroundColor,
  });

  final double width;
  final bool hasBorder;

  final Color? placeHolderColor, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: hasBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: Border.all(
                color: context.theme.colorScheme.onSurface,
                width: 1,
              ))
          : null,
      child: Center(
        child: SizedBox(
          width: width / 1.5,
          height: width / 1.5,
          child: SvgPictureAsset(
            asset: SVGConst.instance.user,
            color: placeHolderColor ?? context.theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
