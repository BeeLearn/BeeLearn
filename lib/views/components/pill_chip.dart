import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  final EdgeInsets? padding;
  final List<Widget> children;
  final BoxDecoration decoration;

  const PillChip({
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 2.0,
    ),
    required this.children,
    required this.decoration,
  });

  @override
  Widget build(context) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        children: children,
      ),
    );
  }
}
