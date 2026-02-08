import 'package:flutter/material.dart';

class ErrorBuilder extends StatelessWidget {
  final String? message;
  final Widget child;

  const ErrorBuilder({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20), 
        child,
      ],
    );
  }
}

