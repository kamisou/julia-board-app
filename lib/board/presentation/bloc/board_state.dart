part of 'board_bloc.dart';

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.width = (BoardConstants.maxWidth - BoardConstants.minWidth) / 4,
    this.artifacts = const [],
    this.undoBuffer = const [],
  });

  final Color color;
  final double width;
  final List<BoardArtifact> artifacts;
  final List<BoardArtifact> undoBuffer;

  BoardState copyWith({
    Color? color,
    double? width,
    List<BoardArtifact>? artifacts,
    List<BoardArtifact>? undoBuffer,
  }) {
    return BoardState(
      color: color ?? this.color,
      width: width ?? this.width,
      artifacts: artifacts ?? this.artifacts,
      undoBuffer: undoBuffer ?? this.undoBuffer,
    );
  }

  @override
  List<Object?> get props => [color, width, artifacts, undoBuffer];
}
