import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

enum TextFieldType { normal, date, disabled }

class TextFieldCuti extends StatelessWidget {
  final String hint;
  final String? label;
  final bool requiredLabel;
  final TextEditingController? controller;
  final TextFieldType type;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const TextFieldCuti({
    super.key,
    required this.hint,
    this.label,
    this.requiredLabel = false,
    this.controller,
    this.type = TextFieldType.normal,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = type == TextFieldType.disabled;
    final bool isDate = type == TextFieldType.date;

    Widget? finalSuffix;

    if (suffixIcon != null) {
      finalSuffix = suffixIcon;
    } else if (isDate) {
      finalSuffix = const Padding(
        padding: EdgeInsets.all(12),
        child: HeroIcon(
          HeroIcons.calendarDays,
          style: HeroIconStyle.outline,
          color: AppColor.disableBorder,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.disableBorder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        SizedBox(
          height: 44,
          child: TextFormField(
            controller: controller,
            readOnly: isDisabled || isDate,
            onTap: isDate ? onTap : null,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColor.disableBorder,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              hintStyle: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color:
                    isDisabled ? AppColor.netral1 : AppColor.disableBorder,
              ),
              suffixIcon: finalSuffix,
              filled: isDisabled,
              fillColor: isDisabled ? AppColor.disable : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    const BorderSide(color: AppColor.disableBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColor.disableBorder,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
