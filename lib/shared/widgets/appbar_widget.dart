import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String user;
  // final String date;

  const AppbarWidget({
    super.key,
    required this.user,
    // required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.netral1,
      elevation: 0,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selamat Datang, $user",
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.netral2,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Senin, 32 Febuari 2045",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                color: AppColor.netral2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
