import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String jamMasuk;
  final String jamPulang;
  final VoidCallback? onClockIn;

  final Color? headerColor;
  
  const CardWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.jamMasuk,
    required this.jamPulang,
    this.onClockIn,
    this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: headerColor ?? AppColor.danger, 
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.netral1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColor.netral1,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _jamItem("Jam masuk", jamMasuk),
                _jamItem("Jam pulang", jamPulang),
              ],
            ),
          ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ButtonLarge(
                label: "Clock in",
                onPressed: onClockIn ?? () {},
                isEnabled: onClockIn != null,
                colorButton: AppColor.succes,
                icon: const HeroIcon(HeroIcons.clock),
              ),
            ),
        ],
      ),
    );
  }

  Widget _jamItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 15,
            color: AppColor.disableBorder,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
