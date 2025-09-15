import 'package:flutter/material.dart';

import '../../../core/init/theme/app_color_scheme.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.isPhoneField = false,
    this.onPrefixChanged,
    this.initialPrefix,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPhoneField;
  final Function(String)? onPrefixChanged;
  final String? initialPrefix;

  @override
  State createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? selectedPrefix;

  final List<String> countryCodes = [
    '+90',
    '+234',
    '+1',
    '+44',
    '+49',
    '+33',
    '+39',
    '+34',
    '+31',
    '+46',
    '+47',
    '+45',
    '+358',
    '+91',
    '+86',
    '+81',
    '+82',
    '+61',
    '+55',
    '+52',
  ];

  @override
  void initState() {
    super.initState();
    selectedPrefix = widget.initialPrefix ?? '+90';

    if (widget.isPhoneField) {
      widget.onPrefixChanged?.call(selectedPrefix!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.isPhoneField) _buildPrefixSelector(),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: const TextStyle(color: Colors.grey),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColorScheme.instance.primary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrefixSelector() {
    return Container(
      width: 80,
      padding: const EdgeInsets.only(left: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPrefix,
          isDense: true,
          items:
              countryCodes.map((String code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(
                    code,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedPrefix = newValue;
              });
              widget.onPrefixChanged?.call(newValue);
            }
          },
        ),
      ),
    );
  }
}
