import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/core/utils/extensions.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/card_widget.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/carousel_widget.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/status_widget.dart';
import 'package:hr_attendance/shared/widgets/table_widget.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/modal_dialog.dart';

class DashboardScreen extends GetView<DashboardController> {
  final VoidCallback onGoToCuti;

  const DashboardScreen({super.key, required this.onGoToCuti});

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      CardDashboard(
        title: "Anda belum absen hari ini!",
        subtitle: "Absensi anda",
        headerColor: AppColor.danger,
        items: [
          CardInfoItem(title: "Jam masuk", value: "-"),
          CardInfoItem(title: "Jam pulang", value: "-"),
        ],
        buttonLabel: "Clock in",
        buttonColor: AppColor.succes,
        icon: const HeroIcon(HeroIcons.clock),
        onPressed: () {},
      ),

      CardDashboard(
        title: "Anda sudah absen hari ini",
        subtitle: "Absensi anda",
        headerColor: AppColor.primary,
        items: [
          CardInfoItem(title: "Jam masuk", value: "07.30"),
          CardInfoItem(title: "Jam pulang", value: "-"),
        ],
        buttonLabel: "Clock out",
        buttonColor: AppColor.danger,
        icon: const HeroIcon(HeroIcons.clock),
        onPressed: () {
          Alertdialog.show(
            animasi: AppAssets.lottieQuestion,
            isQuestion: true,
            message: "Belum masuk jam pulang, ingin lanjut Clock out?",
            onConfirm: () {
              Get.back();
              ModalDialog.show(maxLength: 50, onSubmit: (text) {});
            },
          );
        },
      ),

      CardDashboard(
        title: "Absensi anda sudah lengkap!",
        headerColor: AppColor.succes,
        items: [
          CardInfoItem(title: "Jam masuk", value: "07.30"),
          CardInfoItem(title: "Jam pulang", value: "16.00"),
        ],
      ),

      CardDashboard(
        title: "Info cuti anda",
        headerColor: AppColor.info,
        items: [
          CardInfoItem(title: "Total pengajuan", value: "9"),
          CardInfoItem(title: "Cuti tersisa", value: "4"),
        ],
        buttonLabel: "Ambil Cuti",
        buttonColor: AppColor.primary,
        onPressed: onGoToCuti,
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Container(
        color: AppColor.netral1,
        child: Column(
          children: [
            const SizedBox(height: 10),

            CarouselWidget(
              controller: controller.pageController,
              items: cards,
              onPageChanged: controller.onPageChanged,
            ),

            const SizedBox(height: 10),

            TabBar(
              indicatorColor: AppColor.disableBorder,
              labelColor: AppColor.disableBorder,
              unselectedLabelColor: AppColor.disableBorder,
              dividerColor: Colors.transparent,
              indicatorWeight: 1,
              tabs: const [
                Tab(text: "Absensi bulan ini"),
                Tab(text: "Riwayat cuti bulan ini"),
              ],
            ),

            const SizedBox(height: 15),

            //riwayat absensi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 160,
                            height: 38,
                            child: TextField(
                              onChanged: controller.onAttendanceSearchChanged,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColor.netral2,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search...",
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.search, size: 18),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColor.disableBorder,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        //tabel absensi
                        Expanded(
                          child: Obx(() {
                            return Stack(
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
                                        final item = entry.value;

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Center(
                                                child: Text("${index + 1}"),
                                              ),
                                            ),
                                            DataCell(
                                              Center(child: Text(item.date)),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(item.duration),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  item.clockIn,
                                                  style: TextStyle(
                                                    color: item.clockIn
                                                        .getClockInColor(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  item.clockOut,
                                                  style: TextStyle(
                                                    color: item.clockOut
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

                                if (controller.attendanceList.isEmpty &&
                                    !controller.isAttendanceLoading.value &&
                                    !controller.isAttendanceError.value)
                                  Positioned.fill(
                                    child: Center(
                                      child: Text(
                                        controller.attendanceEmptyMessage,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),

                    //riwayat cuti
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 160,
                            height: 38,
                            child: TextField(
                              onChanged: controller.onLeaveSearchChanged,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColor.netral2,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search...",
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.search, size: 18),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        //tabel cuti
                        Expanded(
                          child: Obx(() {
                            return Stack(
                              children: [
                                CustomDataTable(
                                  columnWidths: [60, 140, 180, 180, 140, 120],
                                  columns: const [
                                    DataColumn(label: Text("No")),
                                    DataColumn(label: Text("Tanggal Cuti")),
                                    DataColumn(label: Text("Alasan Cuti")),
                                    DataColumn(label: Text("Catatan HR")),
                                    DataColumn(label: Text("Last User")),
                                    DataColumn(label: Text("Status Cuti")),
                                  ],
                                  rows: controller.leaveList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              SizedBox(
                                                width: 60,
                                                child: Center(
                                                  child: Text("${index + 1}"),
                                                ),
                                              ),
                                            ),

                                            DataCell(
                                              SizedBox(
                                                width: 140,
                                                child: Center(
                                                  child: Text(
                                                    item.leaveDate,
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            DataCell(
                                              SizedBox(
                                                width: 180,
                                                child: Center(
                                                  child: Text(
                                                    item.reason,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            DataCell(
                                              SizedBox(
                                                width: 180,
                                                child: Center(
                                                  child: Text(
                                                    item.hrNote,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            DataCell(
                                              SizedBox(
                                                width: 140,
                                                child: Center(
                                                  child: Text(
                                                    item.approvedBy,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            DataCell(
                                              SizedBox(
                                                width: 120,
                                                child: Center(
                                                  child: StatusWidget(
                                                    status: item.status,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                      .toList(),
                                ),

                                if (controller.leaveList.isEmpty &&
                                    !controller.isLeaveLoading.value &&
                                    !controller.isLeaveError.value)
                                  Positioned.fill(
                                    child: Center(
                                      child: Text(controller.leaveEmptyMessage),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
