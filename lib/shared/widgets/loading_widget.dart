import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:lottie/lottie.dart';

class LoadingDialogCustom extends StatelessWidget {
  final String message;

  const LoadingDialogCustom({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 220,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppAssets.lottieLoading,),
          const SizedBox(height: 30),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 18,
              color: AppColor.netral2,
            ),
          )
        ],
      ),
    );
  }
}
