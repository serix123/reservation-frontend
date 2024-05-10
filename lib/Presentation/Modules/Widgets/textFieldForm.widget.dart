import 'package:flutter/material.dart';
import 'package:online_reservation/config/app.color.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required TextEditingController? textEditingController,
    this.suffixIcon,
    this.onChanged, this.validator, this.labelText, this.hintText, this.obscureText = false,
  }) : _textEditingController = textEditingController;

  final TextEditingController? _textEditingController;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepPurple.shade50,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: error, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: error, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: kPurpleDark, width: 2),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onChanged: onChanged,
      // setState(() => _email = value),
      validator: (val) =>validator!(val),
    );
  }
}