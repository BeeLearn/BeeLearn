import 'dart:developer';

import 'package:flutter/material.dart';

enum InitializationState {
  success,
  idle,
  pending,
  error,
}

mixin InitializationStateMixin<T extends StatefulWidget> on State<T> {
  final initializationState = ValueNotifier(InitializationState.idle);

  @override
  void initState() {
    super.initState();

    initializationState.value = InitializationState.pending;

    initialize().then((value) {
      initializationState.value = InitializationState.success;
    }).onError((error, stackTrace) {
      initializationState.value = InitializationState.error;

      log(
        "Initialization state failed",
        stackTrace: stackTrace,
        error: error,
      );
    });
  }

  Future<void> initialize();
}
