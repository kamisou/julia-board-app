import 'package:hive_ce/hive_ce.dart';

final class BoardLocalDataSource {
  const BoardLocalDataSource();

  Future<Box<Map>> get _box async {
    if (Hive.isBoxOpen('board')) {
      return Hive.box('board');
    }
    return Hive.openBox('board');
  }

  Future<List<Map<String, Object?>>> get() {
    return _box.then(
      (e) => e.values.map((e) => e.cast<String, Object?>()).toList(),
    );
  }

  Future<void> add(String id, Map<String, Object?> data) {
    return _box.then((e) => e.put(id, data));
  }

  Future<void> undo(String id) {
    return _box.then((e) => e.delete(id));
  }

  Future<void> clear() {
    return _box.then((e) => e.clear());
  }
}
