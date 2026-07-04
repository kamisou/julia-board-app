import 'dart:async';

import 'package:julia_board/board/data/data_source/board_local_data_source.dart';
import 'package:julia_board/board/data/data_source/board_remote_data_source.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';
import 'package:julia_board/board/domain/repository/board_repository_interface.dart';
import 'package:julia_board/core/network/network_info.dart';

final class BoardRepositoryImpl implements BoardRepository {
  const BoardRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final NetworkInfo networkInfo;
  final BoardLocalDataSource localDataSource;
  final BoardRemoteDataSource remoteDataSource;

  @override
  Future<void> add(String boardId, BoardArtifact artifact) async {
    final map = BoardArtifactMapper.toMap(artifact);
    await localDataSource.add(artifact.id, map);
    if (!networkInfo.hasConnection) return;
    return remoteDataSource.updateBoard(boardId, map);
  }

  @override
  Future<void> clear(String boardId) async {
    await localDataSource.clear();
    if (!networkInfo.hasConnection) return;
    return remoteDataSource.clearBoard(boardId);
  }

  @override
  Future<List<BoardArtifact>> fetchBoard(String boardId) async {
    final board = await localDataSource.get();
    if (networkInfo.hasConnection) {
      await remoteDataSource.setBoard(boardId, board);
    }
    return board.map(BoardArtifactMapper.fromMap).toList();
  }

  @override
  Future<void> undo(String boardId, String artifactId) async {
    await localDataSource.undo(artifactId);
    if (!networkInfo.hasConnection) return;
    await remoteDataSource.deleteFromBoard(boardId, artifactId);
  }
}
