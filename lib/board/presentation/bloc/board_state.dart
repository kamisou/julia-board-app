part of 'board_bloc.dart';

enum BoardStatus { initial, loading, success, error }

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.width = (BoardConstants.maxWidth - BoardConstants.minWidth) / 4,
    this.artifacts = const [],
    this.undoBuffer = const [],
    this.status = BoardStatus.initial,
  });

  final Color color;
  final double width;
  final List<BoardArtifact> artifacts;
  final List<BoardArtifact> undoBuffer;
  final BoardStatus status;

  BoardState copyWith({
    Color? color,
    double? width,
    List<BoardArtifact>? artifacts,
    List<BoardArtifact>? undoBuffer,
    BoardStatus? status,
  }) {
    return BoardState(
      color: color ?? this.color,
      width: width ?? this.width,
      artifacts: artifacts ?? this.artifacts,
      undoBuffer: undoBuffer ?? this.undoBuffer,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [color, width, artifacts, undoBuffer, status];
}
