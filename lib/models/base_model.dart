import 'dart:collection';

import 'package:flutter/foundation.dart';

class BaseModel<T> extends ChangeNotifier {
  bool _loading = true;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Map<dynamic, T> _entities = {};

  UnmodifiableListView<T> get items => UnmodifiableListView(_entities.values);

  dynamic getEntityId(T item) {
    throw UnimplementedError();
  }

  dynamic orderBy(T first, T second) {
    throw UnimplementedError();
  }

  T? getEntityById(dynamic id) => _entities[id];

  setAll(List<T> items) {
    _entities = {};

    addAll(items);
  }

  addAll(List<T> items) {
    for (final item in items) {
      final id = getEntityId(item);
      _entities[id] = item;
    }

    notifyListeners();
  }

  bool updateOne(T item) {
    final id = getEntityId(item);

    if (_entities.containsKey(id)) {
      _entities[id] = item;
      notifyListeners();

      return true;
    }

    return false;
  }

  void updateOrAddOne(T item) {
    final id = getEntityId(item);

    _entities[id] = item;

    notifyListeners();
  }

  removeAll(T item) {
    _entities = {};

    notifyListeners();
  }

  removeOne(T item) {
    final id = getEntityId(item);

    _entities.remove(id);

    notifyListeners();
  }
}
