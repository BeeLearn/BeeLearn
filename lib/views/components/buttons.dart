import 'package:flutter/material.dart';

class BorderColor {
  final Color? top, bottom, left, right;

  const BorderColor({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  Color getDefaultColor(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor.withAlpha(70) : Theme.of(context).highlightColor;

  factory BorderColor.symentric({Color? horizontal, Color? vertical}) {
    return BorderColor(
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal,
    );
  }
}

class CustomOutlinedButton extends StatefulWidget {
  final Widget child;
  final bool selected, preventGesture;
  final Color? backgroundColor;
  final BorderColor borderColor;
  final void Function()? onTap;

  const CustomOutlinedButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.selected = false,
    this.preventGesture = false,
    this.borderColor = const BorderColor(),
  });

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  double insetBorderSize = 3.0;
  double insetBottomBorderSize = 6.0;

  late Color defaultColor;
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
  }

  _updateButtonAppearance(bool update) {
    if (update) {
      setState(() {
        insetBottomBorderSize = 4.0;
        backgroundColor = Theme.of(context).colorScheme.primaryContainer.withAlpha(128);
      });
    } else {
      setState(() {
        insetBorderSize = 3.0;
        insetBottomBorderSize = 6.0;
        backgroundColor = widget.backgroundColor;
      });
    }
  }

  _getWidget(Widget child) {
    return widget.preventGesture
        ? child
        : GestureDetector(
            onTap: () {
              if (!widget.selected) {
                widget.onTap!();
              }
            },
            onTapUp: (details) {
              _updateButtonAppearance(false);
            },
            onTapDown: (details) {
              _updateButtonAppearance(true);
            },
            onTapCancel: () {
              _updateButtonAppearance(false);
            },
            child: child,
          );
  }

  @override
  Widget build(BuildContext context) {
    defaultColor = widget.borderColor.getDefaultColor(context);

    return _getWidget(
      AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: const Duration(microseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: widget.selected ? Theme.of(context).colorScheme.primaryContainer.withAlpha(128) : widget.backgroundColor,
          border: Border(
            top: BorderSide(
              width: insetBorderSize,
              color: widget.selected ? Theme.of(context).colorScheme.primaryContainer : widget.borderColor.top ?? defaultColor,
            ),
            bottom: BorderSide(
              width: insetBottomBorderSize,
              color: widget.selected ? Theme.of(context).colorScheme.primaryContainer : widget.borderColor.bottom ?? defaultColor,
            ),
            left: BorderSide(
              width: insetBorderSize,
              color: widget.selected ? Theme.of(context).colorScheme.primaryContainer : widget.borderColor.left ?? defaultColor,
            ),
            right: BorderSide(
              width: insetBorderSize,
              color: widget.selected ? Theme.of(context).colorScheme.primaryContainer : widget.borderColor.right ?? defaultColor,
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
