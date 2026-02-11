import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/features/pengajuan%20cuti/cuti_screen.dart';
import 'package:hr_attendance/features/profile/profile_screen.dart';
import 'package:hr_attendance/shared/widgets/appbar_widget.dart';
import 'package:hr_attendance/shared/widgets/navbar_widget.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onGoToCuti: () => controller.changeIndex(1)),
      const CutiScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.netral1,
        appBar: controller.currentIndex.value == 2
            ? null
            : AppbarWidget(user: "udin"),
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: NavbarWidget(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}
