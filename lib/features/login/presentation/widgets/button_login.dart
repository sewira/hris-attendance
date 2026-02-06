import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class ButtonLogin extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;

  const ButtonLogin({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? AppColor.info : AppColor.disable,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: isEnabled ? onPressed : () {},
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.netral1,
          ),
        ),
      ),
    );
  }
}
