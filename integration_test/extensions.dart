import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> waitUntilVisible(Finder finder) async {
    const duration = Duration(seconds: 10);
    final end = binding.clock.now().add(duration);

    while (finder.hitTestable().evaluate().isEmpty) {
      final now = binding.clock.now();
      if (now.isAfter(end)) {
        throw Exception('waitUntilVisible() timed out');
      }

      await pump(const Duration(milliseconds: 100));
    }
  }
}