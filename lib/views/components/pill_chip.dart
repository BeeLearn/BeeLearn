import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Widget? child;

  const PillChip({
    super.key,
    this.padding,
    this.decoration,
    this.child,
  });

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF25C19B),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: const Text(
        "New",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
