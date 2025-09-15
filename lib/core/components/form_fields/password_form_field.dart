import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/assets/svg_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/managers/button_feedback_manager.dart';
import '../../init/notifier/theme_notifier.dart';
import '../icons/svg_icon.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.isEnabled,
    required this.keyboardType,
    required this.hintText,
    required this.validator,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final bool isEnabled;
  final TextInputType keyboardType;
  final String hintText;
  final String? Function(String?) validator;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SVGConst svgIcons = SVGConst.instance;
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ThemeNotifier>(context)
            .getCustomTheme
            .whiteToDarkerGrey,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: widget.onSubmitted,
        textCapitalization: TextCapitalization.none,
        obscureText: isObscure,
        enabled: widget.isEnabled,
        validator: widget.validator,
        autocorrect: false,
        enableSuggestions: false,
        cursorWidth: 1,
        cursorHeight: SizeConst.cursorHeight,
        style: TextStyle(
            color: Provider.of<ThemeNotifier>(context)
                .getCustomTheme
                .greyToLightBlue,
            fontSize: 16),
        cursorColor: theme.textSelectionTheme.cursorColor,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Provider.of<ThemeNotifier>(context)
                  .getCustomTheme
                  .greyToLightBlue),
          hintText: widget.hintText,
          contentPadding: EdgeInsets.only(top: 12),
          focusColor: context.theme.colorScheme.secondary,
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.error),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPictureAsset(
              asset: svgIcons.lock,
              color: theme.unselectedWidgetColor,
              width: SizeConst.authTextFieldIconWidth - 7.5,
              height: SizeConst.authTextFieldIconHeight,
            ),
          ),
          suffixIcon: IconButton(
            icon: SvgPictureAsset(
              asset: isObscure ? svgIcons.openEye : svgIcons.closeEye,
              color: theme.unselectedWidgetColor,
              width: SizeConst.authTextFieldIconWidth,
            ),
            onPressed: () {
              FeedbackManager.instance.provideHapticFeedback();
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
          suffixStyle: theme.textTheme.titleMedium,
          errorStyle:
              TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 0),
        ),
      ),
    );
  }
}
