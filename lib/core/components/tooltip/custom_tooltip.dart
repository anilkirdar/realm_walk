// ignore_for_file: unused_element

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

enum TooltipPosition { left, right, top, bottom }

enum TooltipArrowPosition { start, center, end }

class CustomTooltipConfig {
  final Color backgroundColor;
  final Color textColor;
  final double maxWidth;
  final EdgeInsets padding;
  final double arrowSize;
  final double borderRadius;
  final Duration showDuration;
  final Duration animationDuration;
  final TooltipPosition position;
  final TooltipArrowPosition arrowPosition;
  final double offset;

  const CustomTooltipConfig({
    this.backgroundColor = const Color(0xFF2ECC71),
    this.textColor = Colors.white,
    this.maxWidth = 200,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.arrowSize = 16,
    this.borderRadius = 4,
    this.showDuration = const Duration(milliseconds: 3000),
    this.animationDuration = const Duration(milliseconds: 250),
    this.position = TooltipPosition.right,
    this.arrowPosition = TooltipArrowPosition.center,
    this.offset = 8,
  });
}

class CustomTooltipController {
  Function(dynamic)? show;
  Function({bool instantly})? hide;
  bool isShown = false;

  void dispose() {
    show = null;
    hide = null;
    isShown = false;
  }
}

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final CustomTooltipController? controller;
  final CustomTooltipConfig config;
  final Widget Function(dynamic) tooltipContentBuilder;
  final bool Function(dynamic)? shouldShowTooltip;

  const CustomTooltip({
    super.key,
    required this.child,
    required this.tooltipContentBuilder,
    this.controller,
    this.config = const CustomTooltipConfig(),
    this.shouldShowTooltip,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isHiding = false;
  String? initialRoute;
  VoidCallback? _routeListener;
  Timer? shownTimer;
  // Store a reference to the router
  GoRouter? _router;

  // NEW: Global key to measure the tooltip box
  final GlobalKey _tooltipBoxKey = GlobalKey();
  // NEW: Extra offset applied to the tooltip box to keep it fully visible in the cross axis.
  Offset _tooltipBoxExtraOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!.show = _showOverlay;
      widget.controller!.hide = _hideOverlay;
      widget.controller!.isShown = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely store the router reference when dependencies change
    _router = GoRouter.maybeOf(context);
  }

  void _showOverlay(dynamic data) {
    _hideOverlay(instantly: true);
    if (!mounted) return;

    if (widget.shouldShowTooltip != null && !widget.shouldShowTooltip!(data)) {
      return;
    }

    _isHiding = false;
    if (widget.controller != null) {
      widget.controller!.isShown = true;
    }
    // final overlayStateStore = context.read<OverlayStateStore>();
    final config = widget.config;

    // Update router reference
    _router = GoRouter.of(context);
    initialRoute = _router?.routerDelegate.currentConfiguration.fullPath;
    _routeListener = () {
      if (_router == null) return;
      final String newRoute =
          _router!.routerDelegate.currentConfiguration.fullPath;
      if (initialRoute != newRoute) {
        widget.controller?.hide?.call(instantly: true);
        _removeRouteListener();
      }
    };
    _router?.routerDelegate.addListener(_routeListener!);

    // Reset extra offset in case of previous show
    _tooltipBoxExtraOffset = Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
              children: [
                // Arrow: always points to the target.
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: _getArrowTargetAnchor(config.position),
                  followerAnchor: _getArrowFollowerAnchor(config.position),
                  offset: _getArrowOffset(config),
                  child: _buildArrow(),
                ),
                // Tooltip Box: positioned adjacent to arrow.
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: _getTooltipBoxTargetAnchor(config.position),
                  followerAnchor: _getTooltipBoxFollowerAnchor(config.position),
                  offset: _getTooltipBoxOffset(config),
                  child: Transform.translate(
                    offset: _tooltipBoxExtraOffset,
                    child: Material(
                      key: _tooltipBoxKey,
                      color: Colors.transparent,
                      // Note: we now only show the content (no arrow here)
                      child: _buildTooltipBox(data),
                    ),
                  ),
                ),
              ],
            )
            .animate(
              onPlay: (controller) => controller.forward(),
              target: _isHiding ? 0 : 1,
            )
            .fadeIn(duration: config.animationDuration)
            .slideX(
              begin: _getSlideAnimation(config.position),
              duration: config.animationDuration,
              curve: Curves.linear,
            );
      },
    );

    // overlayStateStore.insertOverlay(_overlayEntry!);

    // NEW: After the tooltip builds, adjust its box position if it overflows the screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final boxContext = _tooltipBoxKey.currentContext;
      if (boxContext != null) {
        final RenderBox tb = boxContext.findRenderObject() as RenderBox;
        final globalOffset = tb.localToGlobal(Offset.zero);
        final tooltipSize = tb.size;
        final screenSize = MediaQuery.of(context).size;
        Offset adjustment = Offset.zero;
        if (config.position == TooltipPosition.left ||
            config.position == TooltipPosition.right) {
          // Only adjust vertically.
          if (globalOffset.dy < 0) {
            adjustment = Offset(0, -globalOffset.dy);
          } else if (globalOffset.dy + tooltipSize.height > screenSize.height) {
            adjustment = Offset(
              0,
              screenSize.height - (globalOffset.dy + tooltipSize.height),
            );
          }
        } else {
          // For top/bottom tooltips, adjust horizontally.
          if (globalOffset.dx < 0) {
            adjustment = Offset(-globalOffset.dx, 0);
          } else if (globalOffset.dx + tooltipSize.width > screenSize.width) {
            adjustment = Offset(
              screenSize.width - (globalOffset.dx + tooltipSize.width),
              0,
            );
          }
        }
        if (adjustment != _tooltipBoxExtraOffset) {
          setState(() {
            _tooltipBoxExtraOffset = adjustment;
          });
        }
      }
    });

    Future.delayed(config.showDuration, () {
      if (mounted) _hideOverlay();
    });
  }

  void _removeRouteListener() {
    if (_router != null && _routeListener != null) {
      _router!.routerDelegate.removeListener(_routeListener!);
      _routeListener = null;
    }
  }

  Alignment _getTargetAnchor(TooltipPosition position) {
    switch (position) {
      case TooltipPosition.right:
        return Alignment.centerRight;
      case TooltipPosition.left:
        return Alignment.centerLeft;
      case TooltipPosition.top:
        return Alignment.topCenter;
      case TooltipPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  Offset _getOffset(TooltipPosition position, double offset) {
    switch (position) {
      case TooltipPosition.right:
        return Offset(offset, 0);
      case TooltipPosition.left:
        return Offset(-offset, 0);
      case TooltipPosition.top:
        return Offset(0, -offset);
      case TooltipPosition.bottom:
        return Offset(0, offset);
    }
  }

  double _getSlideAnimation(TooltipPosition position) {
    switch (position) {
      case TooltipPosition.right:
        return -0.01;
      case TooltipPosition.left:
        return 0.01;
      case TooltipPosition.top:
        return 0;
      case TooltipPosition.bottom:
        return 0;
    }
  }

  Widget _buildArrow() {
    final config = widget.config;
    return Transform.rotate(
      angle: switch (config.position) {
        TooltipPosition.right => 0,
        TooltipPosition.left => pi,
        TooltipPosition.top => -pi / 2,
        TooltipPosition.bottom => pi / 2,
      },
      child: CustomPaint(
        size: Size(config.arrowSize, config.arrowSize * 1.25),
        painter: TooltipArrowPainter(
          color: config.backgroundColor,
          position: config.position,
        ),
      ),
    );
  }

  Widget _buildTooltipBox(dynamic data) {
    final config = widget.config;
    final isHorizontal =
        config.position == TooltipPosition.left ||
        config.position == TooltipPosition.right;

    return Transform.translate(
      offset: Offset(
        isHorizontal ? (config.position == TooltipPosition.right ? -4 : 4) : 0,
        !isHorizontal
            ? (config.position == TooltipPosition.bottom ? -4 : 4)
            : 0,
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: config.maxWidth),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(config.borderRadius),
        ),
        padding: config.padding,
        child: widget.tooltipContentBuilder(data),
      ),
    );
  }

  void _hideOverlay({bool instantly = false}) {
    _removeRouteListener();
    shownTimer?.cancel();
    shownTimer = null;

    if (_overlayEntry == null) return;

    if (instantly) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isHiding = false;
      if (widget.controller != null) {
        widget.controller!.isShown = false;
      }
      return;
    }

    setState(() => _isHiding = true);
    _overlayEntry?.markNeedsBuild();

    if (!mounted) return;

    Future.delayed(widget.config.animationDuration, () {
      if (!mounted) return;
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isHiding = false;
        if (widget.controller != null) {
          widget.controller!.isShown = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _hideOverlay(instantly: true);
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update router reference in build as well
    _router = GoRouter.maybeOf(context);
    initialRoute ??= _router?.routerDelegate.currentConfiguration.fullPath;

    return CompositedTransformTarget(link: _layerLink, child: widget.child);
  }
}

extension _TooltipPositionHelpers on _CustomTooltipState {
  // For the arrow
  Alignment _getArrowTargetAnchor(TooltipPosition position) {
    switch (position) {
      case TooltipPosition.right:
        return Alignment.centerRight;
      case TooltipPosition.left:
        return Alignment.centerLeft;
      case TooltipPosition.top:
        return Alignment.topCenter;
      case TooltipPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  Alignment _getArrowFollowerAnchor(TooltipPosition position) {
    switch (position) {
      case TooltipPosition.right:
        return Alignment.centerLeft;
      case TooltipPosition.left:
        return Alignment.centerRight;
      case TooltipPosition.top:
        return Alignment.bottomCenter;
      case TooltipPosition.bottom:
        return Alignment.topCenter;
    }
  }

  Offset _getArrowOffset(CustomTooltipConfig config) {
    switch (config.position) {
      case TooltipPosition.right:
        return Offset(config.offset, 0);
      case TooltipPosition.left:
        return Offset(-config.offset, 0);
      case TooltipPosition.top:
        return Offset(0, -config.offset);
      case TooltipPosition.bottom:
        return Offset(0, config.offset);
    }
  }

  // For the tooltip box
  Alignment _getTooltipBoxTargetAnchor(TooltipPosition position) {
    // We use the same anchor as the arrow.
    switch (position) {
      case TooltipPosition.right:
        return Alignment.centerRight;
      case TooltipPosition.left:
        return Alignment.centerLeft;
      case TooltipPosition.top:
        return Alignment.topCenter;
      case TooltipPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  Alignment _getTooltipBoxFollowerAnchor(TooltipPosition position) {
    // Use same follower anchor as the arrow.
    switch (position) {
      case TooltipPosition.right:
        return Alignment.centerLeft;
      case TooltipPosition.left:
        return Alignment.centerRight;
      case TooltipPosition.top:
        return Alignment.bottomCenter;
      case TooltipPosition.bottom:
        return Alignment.topCenter;
    }
  }

  Offset _getTooltipBoxOffset(CustomTooltipConfig config) {
    // Place the box next to the arrow by adding the arrow's size.
    switch (config.position) {
      case TooltipPosition.right:
        return Offset(config.offset + config.arrowSize, 0);
      case TooltipPosition.left:
        return Offset(-config.offset - config.arrowSize, 0);
      case TooltipPosition.top:
        return Offset(0, -config.offset - config.arrowSize);
      case TooltipPosition.bottom:
        return Offset(0, config.offset + config.arrowSize);
    }
  }

  double _getSlideAnimation(TooltipPosition position) {
    // As before, only horizontal sliding for left/right else no slide.
    switch (position) {
      case TooltipPosition.right:
        return -0.01;
      case TooltipPosition.left:
        return 0.01;
      case TooltipPosition.top:
        return 0;
      case TooltipPosition.bottom:
        return 0;
    }
  }
}

class TooltipArrowPainter extends CustomPainter {
  final Color color;
  final TooltipPosition position;

  TooltipArrowPainter({required this.color, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();
    final radius = size.width * 0.2;

    switch (position) {
      case TooltipPosition.right:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(radius, size.height / 2 + radius);
        path.quadraticBezierTo(
          0,
          size.height / 2,
          radius,
          size.height / 2 - radius,
        );
        break;
      case TooltipPosition.left:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(radius, size.height / 2 + radius);
        path.quadraticBezierTo(
          0,
          size.height / 2,
          radius,
          size.height / 2 - radius,
        );
        break;
      case TooltipPosition.top:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(radius, size.height / 2 + radius);
        path.quadraticBezierTo(
          0,
          size.height / 2,
          radius,
          size.height / 2 - radius,
        );
        break;
      case TooltipPosition.bottom:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(radius, size.height / 2 + radius);
        path.quadraticBezierTo(
          0,
          size.height / 2,
          radius,
          size.height / 2 - radius,
        );
        break;
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
