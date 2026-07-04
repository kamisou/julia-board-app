part of 'board_bloc.dart';

enum BoardStatus { loading, success, error }

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.id,
    this.width = (BoardConstants.maxWidth - BoardConstants.minWidth) / 4,
    this.artifacts = const [],
    this.undoBuffer = const [],
    this.status = BoardStatus.loading,
  });

  final String? id;
  final Color color;
  final double width;
  final List<BoardArtifact> artifacts;
  final List<BoardArtifact> undoBuffer;
  final BoardStatus status;

  BoardState copyWith({
    String? Function()? id,
    Color? color,
    double? width,
    List<BoardArtifact>? artifacts,
    List<BoardArtifact>? undoBuffer,
    BoardStatus? status,
  }) {
    return BoardState(
      id: id != null ? id() : this.id,
      color: color ?? this.color,
      width: width ?? this.width,
      artifacts: artifacts ?? this.artifacts,
      undoBuffer: undoBuffer ?? this.undoBuffer,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, color, width, artifacts, undoBuffer, status];
}
