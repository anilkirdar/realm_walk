import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../../init/managers/button_feedback_manager.dart';
import '../../../init/notifier/theme_notifier.dart';
import 'package:provider/provider.dart';

import '../../../init/theme/app_color_scheme.dart';
import '../../toast/toast.dart';
import 'base_network_image.dart';

class CustomNetworkMedia extends StatelessWidget {
  const CustomNetworkMedia(
    this.mediaUrl, {
    super.key,
    this.boxfit = BoxFit.cover,
    this.placeholder,
    this.onTap,
    required this.mediaType,
  });
  final String mediaUrl, mediaType;
  final BoxFit? boxfit;
  final Function()? onTap;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap:
          onTap ??
          () {
            FeedbackManager.instance.provideHapticFeedback();
            if (mediaType == "mp4") {
              // context.push(VideoPlayerView(mediaUrl: mediaUrl));
            } else if (mediaType == "jpg" ||
                mediaType == "jpeg" ||
                mediaType == "png") {
              context.push(
                '/mission/image-viewer',
                extra: {'localImageFile': XFile(mediaUrl)},
              );
            } else {
              flutterErrorToast('Unsupported file format');
            }
          },
      child: Stack(
        children: [
          if (mediaType != "mp4")
            Positioned.fill(
              child: Shimmer.fromColors(
                baseColor:
                    Provider.of<ThemeNotifier>(
                      context,
                    ).getCustomTheme.lightGreyToDarkerGrey,
                highlightColor: AppColorScheme.instance.lightGrey.withValues(
                  alpha: 0.5,
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                ),
              ),
            ),
          if (placeholder != null) Positioned.fill(child: placeholder!),
          if (mediaType != "mp4")
            Positioned.fill(
              child: BaseNetworkImage(
                mediaUrl,
                fit: boxfit,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
              ),
            ),
          if (mediaType == "mp4")
            // TODO: display if media is video
            Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.play_circle_fill_outlined,
                  color: AppColorScheme.instance.secondary,
                  //TODO make it dynamic
                  size: 40,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
