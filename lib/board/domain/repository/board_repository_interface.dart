import 'package:julia_board/board/presentation/data/board_artifact.dart';

abstract interface class BoardRepository {
  Future<List<BoardArtifact>> fetchBoard(String boardId);
  Future<void> add(String boardId, BoardArtifact artifact);
  Future<void> undo(String boardId, String artifactId);
  Future<void> clear(String boardId);
}
