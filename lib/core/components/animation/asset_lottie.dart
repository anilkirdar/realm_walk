// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../constants/utils/ui_constants/sized_box_const.dart';
// import '../../extensions/context_extension.dart';
// import '../../init/notifier/custom_theme.dart';

// class LottieAsset extends StatefulWidget {
//   const LottieAsset({
//     Key? key,
//     required this.lottie,
//     this.height,
//     this.width,
//     this.backgroundColor,
//     this.blurFactor = 0,
//     this.fit = BoxFit.contain,
//     this.repeat = true,
//     this.isFullScreen = false,
//     this.onComplete,
//     this.onStart,
//     this.downLottieWidget,
//     this.downLottieTextStyle,
//   }) : super(key: key);

//   final String lottie;
//   final Widget? downLottieWidget;
//   final TextStyle? downLottieTextStyle;
//   final double? height, width;
//   final Color? backgroundColor;
//   final double blurFactor;
//   final BoxFit fit;
//   final bool repeat;
//   final bool isFullScreen;
//   final VoidCallback? onComplete;
//   final VoidCallback? onStart;

//   @override
//   State<LottieAsset> createState() => _LottieAssetState();
// }

// class _LottieAssetState extends State<LottieAsset>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.isFullScreen ? context.height : widget.height,
//       width: widget.isFullScreen ? context.width : widget.width,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned.fill(
//             child: widget.blurFactor > 0
//                 ? BackdropFilter(
//                     filter: ImageFilter.blur(
//                         sigmaX: widget.blurFactor, sigmaY: widget.blurFactor),
//                     child: Container(
//                       color: widget.backgroundColor ??
//                           CustomColors.white.withOpacity(0.8),
//                     ),
//                   )
//                 : Container(
//                     color: widget.backgroundColor ??
//                         CustomColors.white.withOpacity(0.8),
//                   ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Lottie.asset(
//                 widget.lottie,
//                 height: widget.height,
//                 width: widget.width,
//                 fit: widget.fit,
//                 controller: _controller,
//                 onLoaded: (composition) {
//                   _controller.duration = composition.duration;
//                   if (widget.onStart != null) widget.onStart!();
//                   if (widget.repeat) {
//                     _controller.repeat();
//                   } else {
//                     _controller.forward().whenComplete(() {
//                       if (widget.onComplete != null) widget.onComplete!();
//                     });
//                   }
//                 },
//               ),
//               if (widget.downLottieWidget != null) SizedBoxConst.height100,
//               if (widget.downLottieWidget != null) widget.downLottieWidget!,
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
