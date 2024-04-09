import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;

  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) Text(labelText!, style: TextStyle(color: Colors.black)), // 여기서 색상 조정
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          style: TextStyle(color: Colors.black), // 여기서 색상 조정
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null, // 여기서 색상 조정
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black), // 여기서 색상 조정
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black), // 여기서 색상 조정
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.red), // 여기서 색상 조정
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.red), // 여기서 색상 조정
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}