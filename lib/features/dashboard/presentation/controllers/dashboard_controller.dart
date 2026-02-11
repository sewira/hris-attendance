import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  final PageController pageController = PageController(viewportFraction: 0.94);
  final RxInt currentPage = 0.obs;


  final TextEditingController modalTextController = TextEditingController();
  final RxBool isModalValid = false.obs;
  final RxBool isOverLimit = false.obs;
  final RxInt modalLength = 0.obs;
  final RxString modalMessage = "".obs;

  int modalMaxLength = 50;

  void onModalChanged(String value) {
    modalLength.value = value.length;
    isModalValid.value = value.trim().isNotEmpty;
    isOverLimit.value = value.length > modalMaxLength;
    modalMessage.value = "";
  }

  void validateSubmit() {
    if (modalTextController.text.trim().isEmpty) {
      modalMessage.value = "isi catatan terlebih dahulu";
      return;
    }

    if (modalTextController.text.length > modalMaxLength) {
      modalMessage.value = "karakter melebihi batas";
      return;
    }
  }

  String get modalText => modalTextController.text;

  void resetModal() {
    modalTextController.clear();
    modalLength.value = 0;
    isModalValid.value = false;
    isOverLimit.value = false;
    modalMessage.value = "";
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  

  @override
  void onClose() {
    pageController.dispose();
    modalTextController.dispose();
    super.onClose();
  }
}
