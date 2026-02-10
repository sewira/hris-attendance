import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final PageController controller;
  final List<Widget> items;
  final Function(int)? onPageChanged;
  final double height;

  const CarouselWidget({
    super.key,
    required this.controller,
    required this.items,
    this.onPageChanged,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: controller,
        itemCount: items.length,
        padEnds: false,
        clipBehavior: Clip.none,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: index == items.length - 1 ? 16 : 8,
            ),
            child: items[index],
          );
        },
      ),
    );
  }
}
