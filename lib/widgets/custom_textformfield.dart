import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLines;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.suffixIcon,
    required this.obscureText,
    this.readOnly,
    this.validator,
    this.textCapitalization,
    this.inputFormatters,
    this.label,
    this.keyboardType,
    this.maxLines,
    this.borderRadius,
    this.prefixIcon,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.visiblePassword,
      obscureText: obscureText,
      autofocus: false,
      readOnly: readOnly ?? false,
      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14),
      validator: validator,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 17.0),
        fillColor: Colors.white,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: borderRadius ?? BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        hintStyle:
            TextStyle(color: isDarkMode ? Colors.white60 : Colors.black54),
      ),
    );
  }
}
