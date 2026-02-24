import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/core/utils/app_storage.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat(
      "EEEE, dd MMMM yyyy",
      "id_ID",
    ).format(now);
  }

  @override
  Widget build(BuildContext context) {
    final userName = AppStorage.getUserName() ?? "User";

    return AppBar(
      backgroundColor: AppColor.netral1,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang, $userName",
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.netral2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formattedDate(),
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              color: AppColor.netral2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
