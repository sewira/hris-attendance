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
import 'package:hr_attendance/features/dashboard/presentation/widgets/map_confirmation_dialog.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/modal_dialog.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/selfie_confirmation_dialog.dart';

class DashboardScreen extends GetView<DashboardController> {
  final VoidCallback onGoToCuti;

  const DashboardScreen({super.key, required this.onGoToCuti});

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      Obx(
        () => !controller.isClockInDone.value
            ? CardDashboard(
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
                onPressed: () {
                  MapConfirmationDialog.show(
                    onConfirm: (lat, lng) async {
                      final result = await controller.checkLocation(
                        lat: lat,
                        lng: lng,
                      );
                      if (result == null) return;

                      if (!result.isNear) {
                        Alertdialog.show(
                          animasi: AppAssets.lottieFailed,
                          message:
                              "Anda berada ${result.distanceMeters.toStringAsFixed(0)}m dari kantor (max ${result.maxDistanceMeters.toStringAsFixed(0)}m)",
                        );
                        return;
                      }

                      Get.back();

                      SelfieConfirmationDialog.show(
                        onConfirm: (photo) {
                          Get.back();
                          controller.clockIn(photo);
                        },
                      );
                    },
                  );
                },
              )
            : !controller.isClockOutDone.value
            ? CardDashboard(
                title: "Anda sudah absen hari ini",
                subtitle: "Absensi anda",
                headerColor: AppColor.primary,
                items: [
                  CardInfoItem(
                    title: "Jam masuk",
                    value: controller.todayClockIn.value,
                  ),
                  CardInfoItem(title: "Jam pulang", value: "-"),
                ],
                buttonLabel: "Clock out",
                buttonColor: AppColor.danger,
                icon: const HeroIcon(HeroIcons.clock),
                onPressed: () {
                  final now = TimeOfDay.now();
                  if (now.hour < 17) {
                    Alertdialog.show(
                      animasi: AppAssets.lottieQuestion,
                      message:
                          "Belum masuk jam pulang, ingin lanjut Clock Out?",
                      isQuestion: true,
                      onConfirm: () {
                        Get.back();
                        ModalDialog.show(
                          maxLength: 50,
                          onSubmit: (text) {
                            Get.back();
                            controller.clockOut(note: text);
                          },
                        );
                      },
                    );
                  } else {
                    Alertdialog.show(
                      animasi: AppAssets.lottieQuestion,
                      isQuestion: true,
                      message: "Yakin ingin clock out?",
                      onConfirm: () {
                        Get.back();
                        controller.clockOut();
                      },
                    );
                  }
                },
              )
            : CardDashboard(
                title: "Absensi anda sudah lengkap!",
                headerColor: AppColor.succes,
                items: [
                  CardInfoItem(
                    title: "Jam masuk",
                    value: controller.todayClockIn.value,
                  ),
                  CardInfoItem(
                    title: "Jam pulang",
                    value: controller.todayClockOut.value,
                  ),
                ],
              ),
      ),
      Obx(
        () => CardDashboard(
          title: "Info cuti anda",
          headerColor: AppColor.info,
          items: [
            CardInfoItem(
              title: "Total pengajuan",
              value: controller.totalLeaveTaken.toString(),
            ),
            CardInfoItem(
              title: "Cuti tersisa",
              value: controller.leaveBalance.toString(),
            ),
          ],
          buttonLabel: "Ambil Cuti",
          buttonColor: AppColor.primary,
          onPressed: onGoToCuti,
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
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
                  Tab(text: "Riwayat cuti"),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 15,
                  ),
                  child: TabBarView(
                    children: [_buildAttendance(context), _buildLeave(context)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendance(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(controller.onAttendanceSearchChanged),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            final isEmpty =
                !controller.isAttendanceLoading.value &&
                controller.attendanceEmptyMessage.isNotEmpty;

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
                  rows: controller.attendanceList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text("${index + 1}"))),
                        DataCell(Center(child: Text(item.date))),
                        DataCell(Center(child: Text(item.duration))),
                        DataCell(
                          Center(
                            child: Text(
                              item.clockIn,
                              style: TextStyle(
                                color: item.clockIn.getClockInColor(),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              item.clockOut,
                              style: TextStyle(
                                color: item.clockOut.getClockOutColor(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                if (controller.isAttendanceLoading.value)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (isEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: MediaQuery.removeViewInsets(
                        context: context,
                        removeBottom: true,
                        child: Center(
                          child: Text(
                            controller.attendanceEmptyMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.netral2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLeave(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(controller.onLeaveSearchChanged),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            final isEmpty =
                !controller.isLeaveLoading.value &&
                controller.leaveEmptyMessage.isNotEmpty;

            return Stack(
              children: [
                CustomDataTable(
                  columnWidths: [60, 130, 80, 180, 180, 110, 130],
                  columns: const [
                    DataColumn(label: Text("No")),
                    DataColumn(label: Text("Tanggal Cuti")),
                    DataColumn(label: Text("Durasi")),
                    DataColumn(label: Text("Alasan Cuti")),
                    DataColumn(label: Text("Catatan HR")),
                    DataColumn(label: Text("Last User")),
                    DataColumn(label: Text("Status Cuti")),
                  ],
                  rows: controller.leaveList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return DataRow(
                      cells: [
                        DataCell(Center(child: Text("${index + 1}"))),
                        DataCell(
                          Center(
                            child: Text(
                              item.leaveDate,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              controller.calculateLeaveDuration(
                                item.startDate,
                                item.endDate,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Text(
                              item.reason,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Text(
                              item.hrNote,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        DataCell(Center(child: Text(item.approvedBy))),
                        DataCell(
                          Center(child: StatusWidget(status: item.status)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                if (controller.isLeaveLoading.value)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (isEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: MediaQuery.removeViewInsets(
                        context: context,
                        removeBottom: true,
                        child: Center(
                          child: Text(
                            controller.leaveEmptyMessage,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.netral2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchField(Function(String) onChanged) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 160,
        height: 38,
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: AppColor.disableBorder),
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: const TextStyle(color: AppColor.disablePressed),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(
              Icons.search,
              size: 18,
              color: AppColor.disablePressed,
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
    );
  }
}
