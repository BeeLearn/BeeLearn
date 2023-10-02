import 'package:flutter/material.dart';

class CustomDismissible extends StatefulWidget {
  final Widget child;
  final Function(DismissDirection? direction) getBackground;
  final Future<bool?> Function(DismissDirection direction)? onDismissed;
  final Future<bool?> Function(DismissDirection direction)? confirmDismiss;

  const CustomDismissible({
    this.onDismissed,
    this.confirmDismiss,
    required super.key,
    required this.child,
    required this.getBackground,
  });

  @override
  State<CustomDismissible> createState() => _CustomDismissibleState();
}

class _CustomDismissibleState extends State<CustomDismissible> {
  DismissDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: widget.key!,
      onDismissed: widget.onDismissed,
      background: widget.getBackground(direction),
      onUpdate: (details) {
        if (direction == details.direction) return;

        setState(() => direction = details.direction);
      },
      confirmDismiss: widget.confirmDismiss,
      child: widget.child,
    );
  }
}
