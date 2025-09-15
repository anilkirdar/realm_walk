import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../constants/utils/ui_constants/padding_const.dart';
import '../../constants/utils/ui_constants/size_const.dart';
import '../../init/notifier/theme_notifier.dart';
import '../icons/svg_icon.dart';

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onSubmitted,
    required this.isEnabled,
    required this.keyboardType,
    required this.icon,
    required this.isLogin,
    required this.validator,
    this.formKey,
    this.onChanged, this.hintStyle,
  });
  final String? Function(String?) validator;
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool isLogin, isEnabled;
  final FocusNode focusNode;
  final String hintText;
  final String icon;
  final GlobalKey<State<StatefulWidget>>? formKey;
  final TextStyle? hintStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ThemeNotifier>(context).getCustomTheme.whiteToDarkerGrey,
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
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        textCapitalization: TextCapitalization.none,
        enabled: isEnabled,
        validator: validator,
        autocorrect: false,
        enableSuggestions: false,
        cursorWidth: 1.5,
        cursorHeight: SizeConst.cursorHeight,
        cursorColor: context.theme.textSelectionTheme.cursorColor,
        style: TextStyle(
          color: Provider.of<ThemeNotifier>(context)
                  .getCustomTheme
                  .greyToLightBlue,
            fontSize: 16
        ),
        decoration: InputDecoration(
          hintStyle : TextStyle(color: Provider.of<ThemeNotifier>(context).getCustomTheme.greyToLightBlue),
          hintText: hintText,
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
          prefixIcon: SizedBox(
            child: Padding(
              padding: PaddingConst.all12,
              child: SvgPictureAsset(
                asset: icon,
                color: context.theme.unselectedWidgetColor,
                width: SizeConst.authTextFieldIconWidth,
                height: SizeConst.authTextFieldIconHeight,
              ),
            ),
          ),
          errorStyle: const TextStyle(fontSize: 0),
        ),
      ),
    );
  }
}
