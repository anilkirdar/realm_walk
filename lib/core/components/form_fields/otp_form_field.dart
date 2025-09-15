import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/font_size_const.dart';
import '../../init/notifier/theme_notifier.dart';

class OTPTextField extends StatelessWidget {
  const OTPTextField({
    super.key,
    this.autoFocus = false,
    required this.isNotEmpty,
    required this.controller,
    required this.onChanged,
  });
  final bool autoFocus, isNotEmpty;
  final TextEditingController controller;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.shortestSide * 0.13,
      decoration: BoxDecoration(
        border: Border.all(
            color:
                isNotEmpty ? Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .purpleToWhite : Colors.transparent),
        borderRadius: BorderRadius.circular(5),
        color: context.theme.primaryColor.withOpacity(0.1),
        shape: BoxShape.rectangle,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          controller: controller,
          autofocus: autoFocus,
          decoration: const InputDecoration(border: InputBorder.none),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontSize: FontSizeConst.bigger,
            color: Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .purpleToWhite,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
