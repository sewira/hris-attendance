import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/routes/app_routes.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/core/utils/app_storage.dart';
import 'package:hr_attendance/core/utils/extensions.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';
import 'package:hr_attendance/features/profile/presentation/widgets/profile_widget.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';
import 'package:hr_attendance/shared/widgets/table_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppAssets.profile),
                    const SizedBox(width: 25),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const CircularProgressIndicator();
                      }
                      final profile = controller.profile.value;
                      if (profile == null) return const SizedBox();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 20,
                              color: AppColor.disableBorder,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            profile.department,
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 17,
                              color: AppColor.disableBorder,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(6),
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.infoHover,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppColor.info,
                  borderRadius: BorderRadius.circular(6),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColor.netral1,
                unselectedLabelColor: AppColor.netral1,
                tabs: const [
                  Tab(text: "Data pribadi"),
                  Tab(text: "Data kepegawaian"),
                ],
              ),
            ),

            const SizedBox(height: 5),

            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Obx(() {
                          final profile = controller.profile.value;
                          if (profile == null) return const SizedBox();
                          return ProfileItem(
                            label: "Email",
                            value: profile.email,
                            labelFlex: 2,
                            valueFlex: 9,
                          );
                        }),
                        ProfileItem(
                          label: "Password",
                          value: "********",
                          isIcon: true,
                          onTap: () {
                            Get.toNamed(AppRoutes.password);
                          },
                        ),
                        const ProfileItem(label: "NIP", value: "1234567"),
                        const SizedBox(height: 40),
                        ButtonLarge(
                          label: "Logout",
                          onPressed: () {
                            Alertdialog.show(
                              animasi: AppAssets.lottieQuestion,
                              message: "Ingin keluar dari akun anda",
                              isQuestion: true,
                              onConfirm: () async {
                                await AppStorage.logout();
                                Get.offAllNamed(AppRoutes.login);
                              },
                            );
                          },
                          isEnabled: true,
                          colorButton: AppColor.danger,
                        ),
                      ],
                    ),
                  ),

                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final profile = controller.profile.value;
                    if (profile == null) return const SizedBox();

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileItem(
                            label: "Lama bekerja",
                            value: profile.employmentDuration,
                          ),
                          ProfileItem(
                            label: "Divisi",
                            value: profile.department,
                          ),
                          ProfileItem(
                            label: "Total Cuti Diambil",
                            value: profile.totalLeavesTaken.toString(),
                            labelFlex: 7,
                            valueFlex: 3,
                          ),
                          ProfileItem(
                            label: "Sisa Cuti",
                            value: profile.leaveBalance.toString(),
                            labelFlex: 7,
                            valueFlex: 3,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Riwayat absen",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.disableBorder,
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                height: 35,
                                child: TextField(
                                  onChanged: controller.onSearchChanged,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.netral2,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: TextStyle(
                                      color: AppColor.disableBorder,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: const Icon(
                                      Icons.search,
                                      size: 18,
                                      color: AppColor.disableBorder,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: AppColor.disableBorder,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: AppColor.disableBorder,
                                        width: 1,
                                      ),
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
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                CustomDataTable(
                                  columns: const [
                                    DataColumn(label: Text("No")),
                                    DataColumn(label: Text("Tanggal")),
                                    DataColumn(label: Text("Durasi Kerja")),
                                    DataColumn(label: Text("Clock In")),
                                    DataColumn(label: Text("Clock Out")),
                                  ],
                                  rows: controller.attendanceList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final index = entry.key;
                                        final data = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: Text("${index + 1}"),
                                              ),
                                            ),
                                            DataCell(
                                              Center(child: Text(data.date)),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(data.duration),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  data.clockIn,
                                                  style: TextStyle(
                                                    color: data.clockIn
                                                        .getClockInColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  data.clockOut,
                                                  style: TextStyle(
                                                    color: data.clockOut
                                                        .getClockOutColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                      .toList(),
                                ),

                                if (!controller.isAttendanceLoading.value &&
                                    controller
                                        .attendanceEmptyMessage
                                        .isNotEmpty)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: MediaQuery.removeViewInsets(
                                        context: context,
                                        removeBottom: true,
                                        child: Align(
                                          alignment: const Alignment(0, 0.25),
                                          child: Text(
                                            controller.attendanceEmptyMessage,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColor.netral2,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                if (controller.isAttendanceLoading.value)
                                  const Positioned.fill(
                                    child: IgnorePointer(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
