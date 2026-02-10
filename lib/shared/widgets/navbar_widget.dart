import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class NavbarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: AppColor.netral1,
        border: Border(
          top: BorderSide(
            color: AppColor.dangerBorder,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _item(AppAssets.icHome, "Beranda", 0)),
          Expanded(child: _item(AppAssets.icCalendar, "Pengajuan Cuti", 1)),
          Expanded(child: _item(AppAssets.icUser, "Profile", 2)),
        ],
      ),
    );
  }

  Widget _item(String iconPath, String title, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                isActive
                    ? AppColor.danger
                    : AppColor.disableBorder,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 17,
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                color: isActive
                    ? AppColor.danger
                    : AppColor.disableBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
