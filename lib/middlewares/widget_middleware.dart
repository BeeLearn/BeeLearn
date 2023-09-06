import 'package:beelearn/mixins/initialization_state_mixin.dart';
import 'package:flutter/material.dart';

/// StatefulWidget middleware wrapper
class WidgetMiddleware extends StatefulWidget {
  final Future<void> Function(ValueNotifier<InitializationState>)? onInit;
  final void Function(ValueNotifier<InitializationState>)? onDispose;

  final Widget Function(InitializationState state) builder;

  const WidgetMiddleware({
    super.key,
    this.onInit,
    this.onDispose,
    required this.builder,
  });

  @override
  State<WidgetMiddleware> createState() => _WidgetMiddlewareState();
}

class _WidgetMiddlewareState extends State<WidgetMiddleware> with InitializationStateMixin {
  @override
  Future<void> initialize() async {
    if (widget.onInit != null) await widget.onInit!(initializationState);
  }

  @override
  void dispose() {
    super.dispose();

    initializationState.dispose();
    if (widget.onDispose != null) widget.onDispose!(initializationState);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: initializationState,
      builder: (context, state, child) => widget.builder(state),
    );
  }
}
