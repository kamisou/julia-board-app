import 'dart:async';

import 'package:dio/dio.dart';
import 'package:julia_board/board/data/data_source/local_board_data_source.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';

final class BoardRepository {
  const BoardRepository({
    required this.dio,
    required this.local,
  });

  final Dio dio;
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

  Future<void> sendBoard(List<BoardArtifact> artifacts) {
    const id = String.fromEnvironment('APP_USER');
    return dio.put(
      '/board/$id',
      data: {'artifacts': artifacts.map(BoardArtifactMapper.toMap).toList()},
    );
  }
}
