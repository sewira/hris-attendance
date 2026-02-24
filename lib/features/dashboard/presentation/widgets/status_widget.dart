import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class StatusWidget extends StatelessWidget {
  final String status;

  const StatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade200;
    Color borderColor = Colors.grey;
    Widget icon = const HeroIcon(
      HeroIcons.questionMarkCircle,
      size: 18,
      color: Colors.grey,
    );

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = AppColor.succesHover;
        borderColor = AppColor.succesBorder;
        icon = const HeroIcon(
          HeroIcons.checkCircle,
          size: 16,
          color: AppColor.succesBorder,
        );
        break;
      case 'rejected':
        bgColor = AppColor.dangerHover;
        borderColor = AppColor.dangerBorder;
        icon = const HeroIcon(
          HeroIcons.xCircle,
          size: 16,
          color: AppColor.dangerBorder,
        );
        break;
      case 'pending':
        bgColor = AppColor.warningHover;
        borderColor = AppColor.warningBorder;
        icon = const HeroIcon(
          HeroIcons.clock,
          size: 16,
          color: AppColor.warningBorder,
        );
        break;
    }

    return Container(
      width: 105, 
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            status,
            style: TextStyle(color: borderColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          icon,
        ],
      ),
    );
  }
}
