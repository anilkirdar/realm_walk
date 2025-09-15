import 'package:flutter/material.dart';

class MainFormField extends StatelessWidget {
  const MainFormField(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.onSubmitted,
      this.isEnabled = true,
      this.isUnderLine = true,
      required this.keyboardType,
      this.hintText,
      this.icon,
      this.suffixIconButton,
      required this.validator,
      this.maxLength,
      this.maxLines = 1});
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final bool isEnabled, isUnderLine;
  final TextInputType keyboardType;
  final String? hintText;
  final IconData? icon;
  final Widget? suffixIconButton;
  final String? Function(String?) validator;
  final int? maxLength, maxLines;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmitted,
      textCapitalization: TextCapitalization.none,
      enabled: isEnabled,
      validator: validator,
      maxLength: maxLength,
      maxLines: maxLines,
      autocorrect: false,
      enableSuggestions: false,
      cursorWidth: 1.5,
      cursorHeight: 22,
      cursorColor: theme.textSelectionTheme.cursorColor,
      style: TextStyle(color: Color(0xFF413E69)),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: theme.iconTheme.color,
              )
            : null,
        suffixIcon: suffixIconButton,
        errorStyle: TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 14),
        enabledBorder: isUnderLine
            ? const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
              )
            : InputBorder.none,
        focusedBorder: isUnderLine
            ? UnderlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.secondary),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                  right: Radius.circular(20),
                ),
              )
            : InputBorder.none,
      ),
    );
  }
}
