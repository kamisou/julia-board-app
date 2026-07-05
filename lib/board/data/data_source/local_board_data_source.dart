import 'package:hive_ce/hive_ce.dart';

final class LocalBoardDataSource {
  late final Box<Map> _board;

  Future<void> open() async {
    _board = await Hive.openBox('board');
  }

  Future<void> close() {
    return _board.close();
  }

  List<Map<String, Object?>> get() {
    return _board.values.map((e) => e.cast<String, Object?>()).toList();
  }

  Future<void> add(String id, Map<String, Object?> data) {
    return _board.put(id, data);
  }

  Future<void> remove(String id) {
    return _board.delete(id);
  }

  Future<void> clear() {
    return _board.clear();
  }
}
