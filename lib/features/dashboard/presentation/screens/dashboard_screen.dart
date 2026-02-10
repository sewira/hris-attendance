import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/card_widget.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/carousel_widget.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/status.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/table_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    final List<Widget> cards = [
      CardWidget(
        title: "Anda belum absen hari ini!",
        subtitle: "Absensi anda",
        jamMasuk: "-",
        jamPulang: "-",
        onClockIn: () {},
      ),
      CardWidget(
        title: "Info cuti anda",
        subtitle: "",
        jamMasuk: "-",
        jamPulang: "-",
        headerColor: AppColor.primary,
        onClockIn: () {},
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Container(
        color: AppColor.netral1,
        child: Column(
          children: [
            const SizedBox(height: 20),

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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                child: TabBarView(
                  children: [
                    CustomDataTable(
                      columns: [
                        const DataColumn(label: Text("No")),
                        const DataColumn(label: Text("Tanggal")),

                        DataColumn(
                          label: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Bulan"),
                                IconButton(
                                  icon: const HeroIcon(
                                    HeroIcons.calendar,
                                    size: 20,
                                    color: AppColor.netral1,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const DataColumn(label: Text("Durasi Kerja")),
                        const DataColumn(label: Text("Clock In")),
                        const DataColumn(label: Text("Clock Out")),
                      ],
                      rows: List.generate(
                        10,
                        (index) => DataRow(
                          cells: [
                            DataCell(Center(child: Text("${index + 1}"))),
                            const DataCell(Center(child: Text("10"))),
                            const DataCell(Center(child: Text("Januari"))),
                            const DataCell(Center(child: Text("8 Jam"))),
                            const DataCell(Center(child: Text("08.00"))),
                            const DataCell(Center(child: Text("17.00"))),
                          ],
                        ),
                      ),
                    ),

                    CustomDataTable(
                      columns: const [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Tanggal mulai")),
                        DataColumn(label: Text("Tanggal selesai")),
                        DataColumn(label: Text("Catatan HR")),
                        DataColumn(label: Text("Last user")),
                        DataColumn(label: Text("Status Cuti")),
                      ],
                      rows: List.generate(
                        10,
                        (index) => DataRow(
                          cells: [
                            DataCell(Center(child: Text("${index + 1}")),),
                            DataCell(Center(child: Text("20")),),
                            DataCell(Center(child: Text("30")),),
                            const DataCell(Center(child: Text("-"))),
                            const DataCell(Center(child: Text("Admin"))),
                            const DataCell(Center(child: StatusWidget(status: "Approve"))),
                          ],
                        ),
                      ),
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
