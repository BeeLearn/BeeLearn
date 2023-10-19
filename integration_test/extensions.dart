import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  /// [delayAfter] amount of time to wait after pump is settled
  Future <int> pumpAndSettleWithAfterDelay([Duration delayAfter = const Duration(seconds: 3)]) async {
    final frames = await pumpAndSettle();
    await pump(delayAfter);

    return frames;
  }
}