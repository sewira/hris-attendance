// import 'package:flutter/material.dart';

// class TimeDisplay extends StatelessWidget {
//   final String time;

//   const TimeDisplay({
//     super.key,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           time,
//           style: const TextStyle(
//             fontSize: 64,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 4,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           _getFormattedDate(),
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }

//   String _getFormattedDate() {
//     final now = DateTime.now();
//     final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
//     final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
//   }
// }
