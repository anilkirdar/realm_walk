import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/notifier/theme_notifier.dart';

/*
BUTTON DOCUMENTATION:

Large: Height 54 px, radius: 16 px, shadow: 6px
Continue, Next, Finish vs. en alttaki butonlar


Medium: Height 40 px, radius: 12 px, shadow: 4px
Modallardaki ve küçük butonlar vs.

44-30 px arasını Medium'a çekeceğiz.
Compact: Height 32 px, radius: 12 px, shadow: 4px
Topics, users, favourites vs. compact butonlar

Small: Height 20 px, radius: 8 px, shadow: 4px
Follow, unfollow vs küçük butonlar

29-15 px arasını Medium'a çekeceğiz.

*/
enum ButtonSize {
  small,
  compact,
  medium,
  large,
  shopItem,
  fullImageButton;

  double get height {
    switch (this) {
      case ButtonSize.small:
        return 20;
      case ButtonSize.compact:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 54;
      case ButtonSize.shopItem:
        return 66;
      case ButtonSize.fullImageButton:
        return 74;
    }
  }

  double get fontSize {
    switch (this) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.compact:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
      case ButtonSize.shopItem:
        return 14;
      case ButtonSize.fullImageButton:
        return 8;
    }
  }

  FontWeight get fontWeight {
    switch (this) {
      case ButtonSize.small:
        return FontWeight.w600;
      case ButtonSize.compact:
        return FontWeight.w500;
      case ButtonSize.medium:
        return FontWeight.w600;
      case ButtonSize.large:
        return FontWeight.w600;
      case ButtonSize.shopItem:
        return FontWeight.w600;
      case ButtonSize.fullImageButton:
        return FontWeight.w700;
    }
  }

  double get borderRadius {
    switch (this) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.compact:
        return 8;
      case ButtonSize.medium:
        return 12;
      case ButtonSize.large:
        return 16;
      case ButtonSize.shopItem:
        return 8;
      case ButtonSize.fullImageButton:
        return 11;
    }
  }

  double get shadowOffset {
    switch (this) {
      case ButtonSize.small:
        return 4;
      case ButtonSize.compact:
        return 4;
      case ButtonSize.medium:
        return 4;
      case ButtonSize.large:
        return 6;
      case ButtonSize.shopItem:
        return 4;
      case ButtonSize.fullImageButton:
        return 4;
    }
  }
}

class AnimatedButtonText extends StatelessWidget {
  const AnimatedButtonText({
    super.key,
    required this.text,
    required this.size,
    this.color,
    this.textAlign,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.spacing = 8.0,
  });

  final String text;
  final ButtonSize size;
  final Color? color;
  final TextAlign? textAlign;
  final Widget? icon;
  final IconPosition iconPosition;
  final double spacing;

  TextStyle get _textStyle => TextStyle(
        fontSize: size.fontSize,
        fontWeight: size.fontWeight,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Center(
        child: Text(
          text,
          textAlign: textAlign ?? TextAlign.center,
          style: _textStyle,
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPosition == IconPosition.left) ...[
            icon!,
            SizeConst.dynamicBoxWidth(spacing),
          ],
          Text(
            text,
            textAlign: textAlign ?? TextAlign.center,
            style: _textStyle,
          ),
          if (iconPosition == IconPosition.right) ...[
            SizeConst.dynamicBoxWidth(spacing),
            icon!,
          ],
        ],
      ),
    );
  }
}

enum IconPosition {
  left,
  right,
}

class BaseAnimatedButton extends StatefulWidget {
  const BaseAnimatedButton({
    super.key,
    required this.child,
    this.width,
    this.onTap,
    required this.backgroundColor,
    this.borderColor,
    this.shadowColor,
    required this.size,
  });

  final double? width;
  final Widget child;
  final Function()? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? shadowColor;
  final ButtonSize size;

  @override
  State<BaseAnimatedButton> createState() => _BaseAnimatedButtonState();
}

class _BaseAnimatedButtonState extends State<BaseAnimatedButton>
    with TickerProviderStateMixin {
  bool isTapping = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapping = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapping = false;
        });
      },
      onTap: () {
        setState(() {
          isTapping = true;
        });
        Future.delayed(const Duration(milliseconds: 150), () {
          Future.delayed(const Duration(milliseconds: 50), () {
            widget.onTap?.call();
          });
          setState(() {
            isTapping = false;
          });
        });
      },
      child: Container(
        width: widget.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size.borderRadius),
          boxShadow: [
            BoxShadow(
              color: widget.shadowColor ??
                  Provider.of<ThemeNotifier>(context)
                      .getCustomTheme
                      .beigeToWhite,
              blurRadius: 0,
              offset: Offset(0, widget.size.shadowOffset),
            )
          ],
        ),
        child: Animate(
          autoPlay: false,
          target: isTapping ? 1 : 0,
          effects: [
            MoveEffect(
              begin: Offset(0, 0),
              end: Offset(0, widget.size.shadowOffset),
              duration: Duration(milliseconds: 150),
              curve: Curves.easeInOut,
            ),
          ],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size.borderRadius),
            child: Container(
              width: widget.width,
              height: widget.size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size.borderRadius),
                color: widget.backgroundColor ??
                    Provider.of<ThemeNotifier>(context)
                        .getCustomTheme
                        .whiteToDarkerGrey,
                border: Border.all(
                  color: widget.borderColor ?? Colors.transparent,
                  width: 1,
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
