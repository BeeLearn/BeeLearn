import 'package:flutter/cupertino.dart';

class ValueChangeNotifier<T> extends ChangeNotifier {
  T? _value;

  T get value => _value!;
  T? get nullableValue => _value;

  set value(T value) {
    _value = value;
    notifyListeners();
  }
}
