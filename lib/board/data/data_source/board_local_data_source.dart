import 'package:hive_ce/hive_ce.dart';

final class BoardLocalDataSource {
  const BoardLocalDataSource();

  static const _boxName = 'board';
  Future<Box<Map>> get _box async =>
      Hive.isBoxOpen(_boxName) ? Hive.box(_boxName) : Hive.openBox(_boxName);

  Future<void> dispose() {
    return _box.then((e) => e.close());
  }

  Future<Iterable<Map<String, Object?>>> get() {
    return _box.then((e) => e.values.map((e) => e.cast<String, Object?>()));
  }

  Future<void> add(String id, Map<String, Object?> data) {
    return _box.then((e) => e.put(id, data));
  }

  Future<void> remove(String id) {
    return _box.then((e) => e.delete(id));
  }

  Future<void> clear() {
    return _box.then((e) => e.clear());
  }
}
