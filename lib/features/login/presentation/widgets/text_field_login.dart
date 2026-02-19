import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class TextFieldLogin extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const TextFieldLogin({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontFamily: "Inter",
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColor.disableBorder,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 20,
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
      ),
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
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColor.disableBorder,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColor.disableBorder,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.disableBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.disableBorder, width: 2),
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

class ErrorMassage extends StatelessWidget {
  final String errorMassage;

  const ErrorMassage({super.key, required this.errorMassage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.dangerPressed.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMassage,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.dangerPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}