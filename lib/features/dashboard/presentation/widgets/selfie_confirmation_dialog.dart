import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:image_picker/image_picker.dart';

class SelfieConfirmationDialog extends StatefulWidget {
  final ValueChanged<File>? onConfirm;

  const SelfieConfirmationDialog({super.key, this.onConfirm});

  static Future<void> show({ValueChanged<File>? onConfirm}) {
    return Get.dialog(
      Material(
        color: Colors.black.withValues(alpha: 0.2),
        child: Center(
          child: SelfieConfirmationDialog(onConfirm: onConfirm),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<SelfieConfirmationDialog> createState() =>
      _SelfieConfirmationDialogState();
}

class _SelfieConfirmationDialogState extends State<SelfieConfirmationDialog> {
  File? _capturedImage;

  Future<void> _takeSelfie() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (photo != null) {
      setState(() {
        _capturedImage = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            color: AppColor.primary,
            child: const Text(
              'Konfirmasi Selfie',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.netral1,
              ),
            ),
          ),

          // Image area
          Expanded(
            child: _capturedImage != null
                ? Image.file(
                    _capturedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Image.asset(
                      AppAssets.facePlaceholder,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: _capturedImage != null
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _takeSelfie,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.danger,
                            foregroundColor: AppColor.netral1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Ulangi'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              widget.onConfirm?.call(_capturedImage!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.succes,
                            foregroundColor: AppColor.netral1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Lanjut'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.danger,
                            foregroundColor: AppColor.netral1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _takeSelfie,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.info,
                            foregroundColor: AppColor.netral1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Ambil Foto'),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
