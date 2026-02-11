import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';

class CardDashboard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color headerColor;

  final List<CardInfoItem> items;

  final String? buttonLabel;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final HeroIcon? icon;

  const CardDashboard({
    super.key,
    required this.title,
    this.subtitle,
    required this.headerColor,
    required this.items,
    this.buttonLabel,
    this.onPressed,
    this.buttonColor,
    this.icon,
  });

  bool get hasButton =>
      buttonLabel != null && onPressed != null && buttonColor != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.netral2.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.netral1,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.netral1,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: items
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: _infoItem(e.title, e.value),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  if (hasButton)
                    ButtonLarge(
                      label: buttonLabel!,
                      onPressed: onPressed!,
                      isEnabled: true,
                      colorButton: buttonColor!,
                      icon: icon,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: AppColor.disableBorder,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 25,
            color: AppColor.disableBorder,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class CardInfoItem {
  final String title;
  final String value;

  CardInfoItem({
    required this.title,
    required this.value,
  });
}
