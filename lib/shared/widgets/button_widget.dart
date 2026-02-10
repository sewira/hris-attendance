import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class ButtonSmall extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const ButtonSmall({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.netral1,
          ),
        ),
      ),
    );
  }
}

class ButtonLarge extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color colorButton;
  final Widget? icon;

  const ButtonLarge({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isEnabled,
    required this.colorButton,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? colorButton : AppColor.disable,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,

        child: icon == null
            ? Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.netral1,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.netral1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconTheme(
                    data: const IconThemeData(
                      color: AppColor.netral1,
                      size: 18,
                    ),
                    child: icon!,
                  ),
                ],
              ),
      ),
    );
  }
}
