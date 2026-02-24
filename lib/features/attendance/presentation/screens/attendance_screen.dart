// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/attendance_controller.dart';
// import '../widgets/clock_button.dart';
// import '../widgets/time_display.dart';

// class AttendanceScreen extends StatelessWidget {
//   const AttendanceScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AttendanceController>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance'),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: controller.fetchTodayAttendance,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 const SizedBox(height: 32),
//                 TimeDisplay(time: controller.currentTime.value),
//                 const SizedBox(height: 48),
//                 _buildAttendanceStatus(controller),
//                 const SizedBox(height: 48),
//                 _buildClockButtons(controller),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildAttendanceStatus(AttendanceController controller) {
//     final attendance = controller.todayAttendance.value;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           children: [
//             const Text(
//               'Today\'s Attendance',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildTimeInfo(
//                   'Clock In',
//                   attendance?.clockIn,
//                   Colors.green,
//                 ),
//                 _buildTimeInfo(
//                   'Clock Out',
//                   attendance?.clockOut,
//                   Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeInfo(String label, DateTime? time, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           time != null
//               ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
//               : '--:--',
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildClockButtons(AttendanceController controller) {
//     return Row(
//       children: [
//         Expanded(
//           child: ClockButton(
//             label: 'Clock In',
//             icon: Icons.login,
//             color: Colors.green,
//             onPressed: controller.hasClockedIn ? null : controller.clockIn,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: ClockButton(
//             label: 'Clock Out',
//             icon: Icons.logout,
//             color: Colors.red,
//             onPressed: controller.hasClockedIn && !controller.hasClockedOut
//                 ? controller.clockOut
//                 : null,
//           ),
//         ),
//       ],
//     );
//   }
// }
