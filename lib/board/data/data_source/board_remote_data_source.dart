import 'package:julia_board/core/network/api_client.dart';

final class BoardRemoteDataSource {
  const BoardRemoteDataSource({
    required this.apiClient,
  });

  final ApiClient apiClient;

  Future<String> getBoardId(String deviceId) async {
    final String id = await apiClient.put(
      '/board',
      data: {'deviceId': deviceId},
    );
    return id;
  }

  Future<void> setBoard(String boardId, List<Map<String, Object?>> board) {
    return apiClient.put('/board/$boardId', data: board);
  }

  Future<void> updateBoard(String boardId, Map<String, Object?> update) {
    return apiClient.post('/board/$boardId', data: update);
  }

  Future<void> deleteFromBoard(String boardId, String artifactId) {
    return apiClient.delete('/board/$boardId', query: {'artifact': artifactId});
  }

  Future<void> clearBoard(String boardId) {
    return apiClient.delete('/board/$boardId');
  }
}
