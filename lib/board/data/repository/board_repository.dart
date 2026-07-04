import 'dart:async';

import 'package:julia_board/board/data/data_source/board_local_data_source.dart';
import 'package:julia_board/board/data/data_source/board_remote_data_source.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';
import 'package:julia_board/core/device/device_id.dart';
import 'package:julia_board/core/network/network_info.dart';

final class BoardRepository {
  BoardRepository({
    required this.networkInfo,
    required this.deviceInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final DeviceInfo deviceInfo;
  final NetworkInfo networkInfo;
  final BoardLocalDataSource localDataSource;
  final BoardRemoteDataSource remoteDataSource;
  String? boardId;

  Future<String> getBoardId() async {
    final uniqueId = await deviceInfo.getUniqueId();
    final id = await remoteDataSource.getBoardId(uniqueId);
    boardId = id;
    return id;
  }

  Future<void> add(BoardArtifact artifact) async {
    final map = BoardArtifactMapper.toMap(artifact);
    await localDataSource.add(artifact.id, map);
    if (networkInfo.hasConnection && boardId != null) {
      return remoteDataSource.updateBoard(boardId!, map);
    }
  }

  Future<void> clear() async {
    await localDataSource.clear();
    if (networkInfo.hasConnection && boardId != null) {
      return remoteDataSource.clearBoard(boardId!);
    }
  }

  Future<List<BoardArtifact>> fetchBoard() async {
    final board = await localDataSource.get();
    if (networkInfo.hasConnection && boardId != null) {
      remoteDataSource.setBoard(boardId!, board).ignore();
    }
    return board.map(BoardArtifactMapper.fromMap).toList();
  }

  Future<void> delete(String artifactId) async {
    await localDataSource.undo(artifactId);
    if (networkInfo.hasConnection && boardId != null) {
      await remoteDataSource.deleteFromBoard(boardId!, artifactId);
    }
  }
}
