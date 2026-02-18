import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/features/pengajuan_cuti/presentation/screens/cuti_screen.dart';
import 'package:hr_attendance/features/profile/presentation/screens/profile_screen.dart';
import 'package:hr_attendance/shared/widgets/appbar_widget.dart';
import 'package:hr_attendance/shared/widgets/navbar_widget.dart';

class MainScreen extends GetView<MainController> {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onGoToCuti: () => controller.changeIndex(1)),
      CutiScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.netral1,

        appBar: controller.currentIndex.value == 0
            ? AppbarWidget()
            : null,

        body: SafeArea(
          child: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
        ),

        bottomNavigationBar: NavbarWidget(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}
