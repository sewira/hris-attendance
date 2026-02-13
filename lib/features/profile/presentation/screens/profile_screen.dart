import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';
import 'package:hr_attendance/features/profile/presentation/widgets/profile_widget.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';
import 'package:hr_attendance/shared/widgets/date_dialog.dart';
import 'package:hr_attendance/shared/widgets/table_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Tommy Darvito W",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Mobile",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

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
                labelStyle: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                tabs: const [
                  Tab(text: "Data pribadi"),
                  Tab(text: "Data kepegawaian"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    children: [
                      const ProfileItem(
                        label: "Email",
                        value: "tommy@gmail.com",
                      ),
                      const ProfileItem(
                        label: "Password",
                        value: "************",
                        isIcon: true,
                      ),
                      const ProfileItem(label: "NIP", value: "1234567"),

                      const SizedBox(height: 40),

                      ButtonLarge(
                        label: "Logout",
                        onPressed: () {},
                        isEnabled: true,
                        colorButton: AppColor.danger,
                      ),
                    ],
                  ),

                  ListView(
                    children: [
                      const ProfileItem(
                        label: "Lama bekerja",
                        value: "1 Tahun",
                      ),
                      const ProfileItem(label: "Divisi", value: "Mobile"),
                      const ProfileItem(
                        label: "Banyak cuti diambil",
                        value: "9",
                      ),
                      const ProfileItem(
                        label: "Sisa cuti tersedia",
                        value: "4",
                      ),

                      SizedBox(height: 20),

                      CustomDataTable(
                        showSearch: false,
                        columns: [
                          const DataColumn(label: Text("No")),

                          DataColumn(
                            label: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Tanggal"),
                                  IconButton(
                                    icon: const HeroIcon(
                                      HeroIcons.calendar,
                                      size: 20,
                                      color: AppColor.netral1,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      await showDateDialog(
                                        context,
                                        controller.filterDateController,
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
                              const DataCell(
                                Center(child: Text("20 Jan 2026")),
                              ),
                              const DataCell(Center(child: Text("8 Jam"))),
                              const DataCell(Center(child: Text("08.00"))),
                              const DataCell(Center(child: Text("17.00"))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
