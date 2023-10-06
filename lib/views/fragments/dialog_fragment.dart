import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../globals.dart';

const EdgeInsets _defaultInsetPadding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

class DialogFragment extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets insetPadding;
  final Widget Function(BuildContext) builder;

  const DialogFragment({
    super.key,
    required this.builder,
    required this.alignment,
    this.insetPadding = _defaultInsetPadding,
  });

  @override
  Widget build(context) {
    return ResponsiveBreakpoints(
      breakpoints: defaultBreakpoints,
      child: ResponsiveDialogFragment(
        builder: builder,
        alignment: alignment,
        insetPadding: insetPadding,
      ),
    );
  }
}

class ResponsiveDialogFragment extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets insetPadding;
  final Widget Function(BuildContext) builder;

  const ResponsiveDialogFragment({
    super.key,
    required this.builder,
    required this.alignment,
    required this.insetPadding,
  });

  @override
  Widget build(context) {
    final widthMultiplier = ResponsiveBreakpoints.of(context).screenWidth > 960 ? 0.45 : 0.75;

    return ResponsiveBreakpoints.of(context).largerThan(MOBILE)
        ? Dialog(
            insetPadding: insetPadding,
            alignment: alignment,
            clipBehavior: insetPadding == EdgeInsets.zero ? Clip.none : Clip.hardEdge,
            child: SizedBox(
              width: ResponsiveBreakpoints.of(context).screenWidth * widthMultiplier,
              child: builder(context),
            ),
          )
        : builder(context);
  }
}
