import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isIcon;
  final VoidCallback? onTap; 

  const ProfileItem({
    super.key,
    required this.label,
    required this.value,
    this.isIcon = false,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.disableBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 17,
                fontWeight: FontWeight.w300,
                color: AppColor.disablePressed,
              ),
            ),
          ),

          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 17,
                      color: AppColor.disableBorder,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (isIcon) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onTap, 
                    child: const HeroIcon(
                      HeroIcons.pencilSquare,
                      size: 26,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
