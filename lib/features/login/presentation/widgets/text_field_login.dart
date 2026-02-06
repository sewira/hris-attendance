import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class TextFieldLogin extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const TextFieldLogin({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.disableBorder,
          ),

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              color: AppColor.disableBorder,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.disableBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.disableBorder,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextFieldPassword extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback onToggle;

  const TextFieldPassword({
    super.key,
    required this.hint,
    this.controller,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: "Inter",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColor.disableBorder,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.disableBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.disableBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.disableBorder,
            width: 2,
          ),
        ),
        suffixIcon: IconButton(
          icon: HeroIcon(
            obscureText ? HeroIcons.eyeSlash : HeroIcons.eye,
            style: HeroIconStyle.outline,
            color: AppColor.disableBorder,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
