import 'package:julia_board/board/presentation/data/board_stroke.dart';

abstract interface class BoardRepository {
  Future<void> sendBoard(List<BoardStroke> strokes);
}
