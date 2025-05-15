import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final String hint;
  final TextEditingController ctrl;
  final String? Function(String?) validator;
  final bool obscure;

  const LoginTextFormField({
    Key? key,
    required this.hint,
    required this.ctrl,
    required this.validator,
    this.obscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}