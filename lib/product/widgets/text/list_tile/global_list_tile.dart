import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/adaptive_widgets/adaptive_circular_indicator.dart';
import '../../../../core/components/icons/svg_icon.dart';
import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/enums/list_tile_size_enum.dart';
import '../../../../core/init/notifier/theme_notifier.dart';
import '../../../../core/init/theme/app_color_scheme.dart';

class GlobalListTile extends StatelessWidget {
  GlobalListTile({
    super.key,
    required this.title,
    this.description,
    this.leadingIcon,
    this.selectedLeadingIcon,
    this.leadingWidget,
    this.leadingEmoji,
    this.onTap,
    this.isSelected = false,
    this.size = ListTileSize.large,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.titleStyle,
    this.descriptionStyle,
    this.leadingIconColor,
    this.selectedLeadingIconColor,
  }) {
    _validateUsage();
  }

  final dynamic title;
  final String? description;
  final String? leadingIcon;
  final String? selectedLeadingIcon;
  final Widget? leadingWidget;
  final String? leadingEmoji;
  final VoidCallback? onTap;
  final bool isSelected;
  final ListTileSize size;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Color? leadingIconColor;
  final Color? selectedLeadingIconColor;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final defaultBackgroundColor =
        backgroundColor ?? themeNotifier.getCustomTheme.whiteToDarkerGrey;
    final defaultSelectedBackgroundColor =
        selectedBackgroundColor ?? AppColorScheme.instance.primary;

    return Container(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            color: isSelected
                ? defaultSelectedBackgroundColor
                : defaultBackgroundColor,
            borderRadius: switch (size) {
              ListTileSize.small => BorderRadius.circular(6),
              ListTileSize.medium ||
              ListTileSize.large =>
                BorderRadius.circular(8),
              ListTileSize.xlarge => BorderRadius.circular(12),
            },
            border: Border.all(
              color: isSelected
                  ? AppColorScheme.instance.primary
                  : themeNotifier.getCustomTheme.purpleToWhite,
            ),
          ),
          child: Row(
            children: [
              if (_shouldShowLeading) ...[
                Padding(
                  padding: PaddingConst.left16,
                  child: _buildLeading(context, themeNotifier),
                ),
                const SizedBox(width: 16),
              ] else
                const SizedBox(
                  width: 24,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildContent(context, themeNotifier),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeNotifier themeNotifier) {
    switch (size) {
      case ListTileSize.xlarge:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title is String
                ? Text(title, style: _getTitleStyle(context, themeNotifier))
                : title,
            if (description != null) ...[
              Text(
                description!,
                style: _getDescriptionStyle(context, themeNotifier),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ],
        );

      case ListTileSize.large:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: _getTitleStyle(context, themeNotifier)),
            if (description != null) ...[
              Text(
                description!,
                style: _getDescriptionStyle(context, themeNotifier),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ],
        );

      case ListTileSize.medium:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title is String
                ? Text(
                    title,
                    style: _getTitleStyle(context, themeNotifier),
                    textAlign: TextAlign.center,
                  )
                : title,
          ],
        );
      case ListTileSize.small:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title is String
                ? Text(
                    title,
                    style: _getTitleStyle(context, themeNotifier),
                    textAlign: TextAlign.center,
                  )
                : title,
          ],
        );
    }
  }

  bool get _shouldShowLeading {
    switch (size) {
      case ListTileSize.xlarge:
      case ListTileSize.large:
        return leadingIcon != null ||
            leadingWidget != null ||
            leadingEmoji != null;
      case ListTileSize.medium:
        return leadingIcon != null ||
            leadingWidget != null ||
            leadingEmoji != null;
      case ListTileSize.small:
        return false;
    }
  }

  bool get _shouldShowDescription {
    return (size == ListTileSize.xlarge || size == ListTileSize.large) &&
        description != null;
  }

  bool _isNetworkPath(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool _isStringPath(String path) {
    return path.startsWith('string://');
  }

  Widget _buildLeading(BuildContext context, ThemeNotifier themeNotifier) {
    if (leadingEmoji != null) {
      return Text(
        leadingEmoji!,
        style: TextStyle(
          fontSize: size.iconSize,
        ),
      );
    }

    if (leadingWidget != null) {
      return leadingWidget!;
    }

    final iconColor = isSelected
        ? selectedLeadingIconColor ?? Colors.white
        : leadingIconColor ?? themeNotifier.getCustomTheme.purpleToWhite;

    final iconPath = isSelected && selectedLeadingIcon != null
        ? selectedLeadingIcon!
        : leadingIcon!;

    if (iconPath == '') {
      return AdaptiveCPI(
        size: size.iconSize / 2,
      );
    }

    return _isNetworkPath(iconPath)
        ? SvgPictureNetwork(
            url: iconPath,
            color: iconColor,
            width: size.iconSize,
            height: size.iconSize,
            shouldSetColor:
                leadingIconColor != null || selectedLeadingIconColor != null,
          )
        : _isStringPath(iconPath)
            ? SvgPictureString(
                asset: iconPath,
                color: iconColor,
                width: size.iconSize,
                height: size.iconSize,
                shouldSetColor: leadingIconColor != null ||
                    selectedLeadingIconColor != null,
              )
            : SvgPictureAsset(
                asset: iconPath,
                color: iconColor,
                width: size.iconSize,
                height: size.iconSize,
              );
  }

  TextStyle _getTitleStyle(BuildContext context, ThemeNotifier themeNotifier) {
    final baseStyle = titleStyle ?? Theme.of(context).textTheme.titleMedium;
    final color = isSelected
        ? Colors.white
        : leadingIconColor ?? themeNotifier.getCustomTheme.purpleToLightBlue;

    return baseStyle!.copyWith(
      color: color,
      fontSize: size == ListTileSize.small ? 14 : 16,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _getDescriptionStyle(
      BuildContext context, ThemeNotifier themeNotifier) {
    final baseStyle =
        descriptionStyle ?? Theme.of(context).textTheme.bodyMedium;
    final color = isSelected
        ? Colors.white.withOpacity(1)
        : leadingIconColor ?? themeNotifier.getCustomTheme.purpleToLightBlue;

    return baseStyle!.copyWith(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  void _validateUsage() {
    if (!kDebugMode) return;

    final guidelines = <String>[];

    // Size-specific validations
    switch (size) {
      case ListTileSize.small:
        if (leadingIcon != null ||
            leadingWidget != null ||
            leadingEmoji != null) {
          guidelines
              .add('⚠️ Small size does not support leading icons or widgets');
        }
        break;
      case ListTileSize.medium:
      case ListTileSize.large:
      case ListTileSize.xlarge:
        if (description != null && size == ListTileSize.medium) {
          guidelines
              .add('⚠️ Description is only visible in large and xlarge sizes');
        }
        break;
    }

    // Icon validations
    if (leadingIcon != null && selectedLeadingIcon == null && isSelected) {
      guidelines.add(
          '💡 Consider providing selectedLeadingIcon when using isSelected');
    }

    if (leadingIcon != null && leadingWidget != null) {
      guidelines.add('⚠️ Avoid using both leadingIcon and leadingWidget');
    }

    // Print usage guidelines if any exist
    if (guidelines.isNotEmpty) {
      print('\n🎯 GlobalListTile Usage Guidelines:');
      print('Size: $size');
      for (final guideline in guidelines) {
        print(guideline);
      }
      print('''
📝 Quick Reference:
- Small: No icons, single line title only.
- Medium: Icons and emojis supported, single line title.
- Large: Icons and emojis supported, title + description.
- XLarge: Icons and emojis supported, title + multiline description.
check figma for more details.
''');
    }
  }
}
