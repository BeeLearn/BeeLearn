import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  final EdgeInsets? padding;
  final List<Widget> children;
  final BoxDecoration? decoration;

  final void Function()? onTap;

  const PillChip({
    super.key,
    this.onTap,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 2.0,
    ),
    required this.children,
  });

  @override
  Widget build(context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: decoration ??
            BoxDecoration(
              border: Border.all(color: Theme.of(context).splashColor),
              borderRadius: BorderRadius.circular(100.0),
            ),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
