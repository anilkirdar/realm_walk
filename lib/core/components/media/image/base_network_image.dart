import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/assets/image_const.dart';
import '../../../constants/utils/ui_constants/padding_const.dart';
import '../../../init/theme/app_color_scheme.dart';
import '../../adaptive_widgets/adaptive_circular_indicator.dart';

typedef ImageErrorWidgetBuilder = Widget Function(
    BuildContext context, Object error, StackTrace? stackTrace);

class BaseNetworkImage extends StatelessWidget {
  const BaseNetworkImage(
    this.url, {
    super.key,
    this.fit,
    this.height,
    this.width,
    this.errorBuilder,
    this.errorPadding,
    this.errorImage,
    this.loadingImage,
    this.backgroundColor,
    this.errorColor,
  });
  final String? url;
  final BoxFit? fit;
  final double? height, width;
  final ImageErrorWidgetBuilder? errorBuilder;

  final EdgeInsets? errorPadding;
  final String? errorImage, loadingImage;
  final Color? backgroundColor, errorColor;

  @override
  Widget build(BuildContext context) {
    return url == '' || url == null
        ? buildPlaceHolderImage()
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            height: height,
            width: width,
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            placeholderFadeInDuration: Duration.zero,
            placeholder: errorBuilder != null
                ? (context, url) {
                    return errorBuilder!(context, url, null);
                  }
                : (context, url) {
                    return AdaptiveCPI();
                  },
            errorWidget: (context, url, error) {
              return buildPlaceHolderImage();
            },
          );
  }

  Padding buildPlaceHolderImage() {
    return Padding(
      padding: PaddingConst.all8,
      child: Image.asset(
        errorImage ?? ImageConst.instance.userPrimary,
        color: errorColor ?? AppColorScheme.instance.primary,
      ),
    );
  }
}
