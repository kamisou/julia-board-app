import 'dart:async';

import 'package:julia_board/board/data/data_source/board_local_data_source.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';

final class BoardRepository {
  const BoardRepository({
    required this.localDataSource,
  });

  final BoardLocalDataSource localDataSource;

  Future<void> dispose() {
    return localDataSource.dispose();
  }

  Future<void> addArtifact(BoardArtifact artifact) async {
    final data = BoardArtifactMapper.toMap(artifact);
    await localDataSource.add(artifact.id, data);
  }

  Future<void> removeArtifact(BoardArtifact artifact) async {
    await localDataSource.remove(artifact.id);
  }

  Future<void> clearBoard() async {
    await localDataSource.clear();
  }

  Future<List<BoardArtifact>> restoreBoard() async {
    final values = await localDataSource.get();
    return values.map(BoardArtifactMapper.fromMap).toList();
  }
}
