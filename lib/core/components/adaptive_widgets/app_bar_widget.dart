import 'package:flutter/material.dart';

import '../../../core/components/button/pop_button.dart';
import '../../../core/extensions/context_extension.dart';
import '../../extensions/string_extension.dart';
import '../button/exit_to_main_view_button.dart';

class AppBarConst extends StatelessWidget implements PreferredSizeWidget {
  const AppBarConst({
    super.key,
    this.leading,
    this.trailing,
    required this.title,
    this.implyLeading = true,
    this.implyExitButton = false,
    this.centerTitle = false,
    this.titleStyle,
    this.onPop,
    this.onTapExitButton,
  });
  final Widget? leading, trailing;
  final String title;
  final bool implyLeading, implyExitButton, centerTitle;
  final TextStyle? titleStyle;
  final Function()? onPop;
  final Function()? onTapExitButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: centerTitle,
        leading:
            implyLeading
                ? Padding(
                  padding:
                      context.sLanguageCode.isRTL
                          ? const EdgeInsets.only(right: 24)
                          : const EdgeInsets.only(left: 24),
                  child: SizedBox(
                    height: 28,
                    width: double.infinity,
                    child: Center(child: leading ?? PopButton(onPop: onPop)),
                  ),
                )
                : Container(),
        actions: [
          if (implyExitButton || trailing != null)
            Padding(
              padding:
                  context.sLanguageCode.isRTL
                      ? const EdgeInsets.only(left: 24)
                      : const EdgeInsets.only(right: 24),
              child: SizedBox(
                height: 28,
                child: Center(
                  child:
                      implyExitButton
                          ? ExitToMainViewButton(onTap: onTapExitButton)
                          : trailing,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(44); // 28+16 (bottom padding)
}
