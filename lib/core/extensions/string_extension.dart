import 'package:flutter/material.dart';

import '../constants/app/app_const.dart';
import 'double_extension.dart';

extension CustomStringExtension on String {
  bool get isValidEmail => contains(RegExp(AppConst.emailRegex)) ? true : false;

  String capitalize() {
    if (isEmpty) return '';
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String get roundUpToK {
    if (int.parse(this) < 1000) {
      return this;
    } else if (int.parse(this) < 1000000) {
      return '${(int.parse(this) / 1000).toStringAsFixed(1)}k';
    } else if (int.parse(this) < 1000000000) {
      return '${(int.parse(this) / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(int.parse(this) / 1000000000).toStringAsFixed(1)}B';
    }
  }

  String get roundUpToKSimple {
    if (int.parse(this) < 1000) {
      return this;
    } else if (int.parse(this) < 1000000) {
      final value = (int.parse(this) / 1000).truncateToDecimalPlaces(1);
      return '${value % 1 == 0.0 ? value.toInt() : value}k';
    } else if (int.parse(this) < 1000000000) {
      final value = (int.parse(this) / 1000000).truncateToDecimalPlaces(1);
      return '${value % 1 == 0.0 ? value.toInt() : value}M';
    } else {
      final value = (int.parse(this) / 1000000000).truncateToDecimalPlaces(1);
      return '${value % 1 == 0.0 ? value.toInt() : value}B';
    }
  }

  List<Widget> mapWithWidgets(Map<String, Widget Function(int, int)> map,
      Widget Function(String) defaultWidget) {
    final chunks = split(' ');
    final widgets = <Widget>[];

    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];

      final key = map.keys
          .firstWhere((element) => chunk.contains(element), orElse: () => '');
      if (key.isNotEmpty && chunk.contains(key)) {
        final innerChunks =
            chunk.split(key).where((element) => element.isNotEmpty).toList();
        if (innerChunks.length == 1) {
          if (chunk.startsWith(key)) {
            widgets.add(map[key]!(i, chunks.length - 1));
            widgets.add(defaultWidget(innerChunks[0]));
            if (i != chunks.length - 1) {
              widgets.add(defaultWidget(' '));
            }
          } else {
            widgets.add(defaultWidget(innerChunks[0]));
            widgets.add(map[key]!(i, chunks.length - 1));
            if (i != chunks.length - 1) {
              widgets.add(defaultWidget(' '));
            }
          }
          continue;
        }

        widgets.add(map[key]!(i, chunks.length - 1));
        if (i != chunks.length - 1) {
          widgets.add(defaultWidget(' '));
        }
        continue;
      }

      widgets.add(defaultWidget(chunk));
      if (i != chunks.length - 1) {
        widgets.add(defaultWidget(' '));
      }
    }

    return widgets;
  }

  List<InlineSpan> mapWithInlineSpan(Map<String, Widget Function(int, int)> map,
      Widget Function(String) defaultWidget) {
    final chunks = split(' ');
    final widgets = <Widget>[];

    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];

      final key = map.keys
          .firstWhere((element) => chunk.contains(element), orElse: () => '');
      if (key.isNotEmpty && chunk.contains(key)) {
        final innerChunks =
            chunk.split(key).where((element) => element.isNotEmpty).toList();
        if (innerChunks.length == 1) {
          if (chunk.startsWith(key)) {
            widgets.add(map[key]!(i, chunks.length - 1));
            // Add appropriate spacing
            widgets.add(defaultWidget(" " + innerChunks[0]));
            if (i != chunks.length - 1) {
              widgets.add(defaultWidget(' '));
            }
          } else {
            widgets.add(defaultWidget(innerChunks[0] + " "));
            widgets.add(map[key]!(i, chunks.length - 1));
            if (i != chunks.length - 1) {
              widgets.add(defaultWidget(' '));
            }
          }
          continue;
        }

        widgets.add(map[key]!(i, chunks.length - 1));
        if (i != chunks.length - 1) {
          widgets.add(defaultWidget(' '));
        }
        continue;
      }

      widgets.add(defaultWidget(chunk));
      if (i != chunks.length - 1) {
        widgets.add(defaultWidget(' '));
      }
    }

    return widgets.map((widget) {
      if (widget is Text) {
        // Handle Text widgets with proper style conversion
        return TextSpan(
          text: widget.data,
          style: widget.style?.copyWith(
            // Add letter spacing for better readability
            letterSpacing: 0.48,
            // Ensure height is appropriate
            height: 1.2,
          ),
        );
      } else if (widget is RichText) {
        // Handle RichText widgets
        return widget.text;
      } else {
        // For any other widget, use WidgetSpan with proper spacing
        return WidgetSpan(
          child: widget,
          alignment: PlaceholderAlignment.middle,
          // Add baseline offset to align inline widgets better
          baseline: TextBaseline.alphabetic,
          style: TextStyle(height: 1.2),
        );
      }
    }).toList();
  }

  List<TextSpan> mapSingleWithRichText(
      String key,
      TextSpan Function(int, int) widget,
      TextSpan Function(String) defaultWidget) {
    var mutableThis = this;
    final widgets = <TextSpan>[];

    final startIndex = mutableThis.indexOf(key);
    if (startIndex == -1) return [defaultWidget(mutableThis)];

    final endIndex = startIndex + key.length;

    final beforeNeedle = mutableThis.substring(0, startIndex);
    final afterNeedle = mutableThis.substring(endIndex, mutableThis.length);

    widgets.addAll([
      defaultWidget(beforeNeedle),
      widget(0, mutableThis.length - 1),
      defaultWidget(afterNeedle),
    ]);

    return widgets;
  }

  bool get isRTL => contains(RegExp(r'ar|he|ur|fa|ps|syr|dv|yi'));
}
