import 'dart:async';

import 'package:julia_board/board/data/data_source/local_board_data_source.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';

final class BoardRepository {
  BoardRepository({
    required this.local,
  });

  final LocalBoardDataSource local;

  Future<void> open() async {
    return local.open();
  }

  Future<void> close() async {
    await local.close();
  }

  Future<void> addArtifact(BoardArtifact artifact) async {
    final data = BoardArtifactMapper.toMap(artifact);
    return local.add(artifact.id, data);
  }

  Future<void> removeArtifact(BoardArtifact artifact) async {
    return local.remove(artifact.id);
  }

  Future<void> clearBoard() async {
    return local.clear();
  }

  Future<List<BoardArtifact>> getBoard() async {
    final data = local.get();
    return data.map(BoardArtifactMapper.fromMap).toList();
  }
}
