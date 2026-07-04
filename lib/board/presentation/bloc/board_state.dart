part of 'board_bloc.dart';

enum BoardStatus { initial, loading, success, error }

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.width = 4.0,
    this.artifacts = const [],
  });

  final Color color;
  final double width;
  final List<BoardArtifact> artifacts;

  BoardState copyWith({
    Color? color,
    double? width,
    List<BoardArtifact>? artifacts,
  }) {
    return BoardState(
      color: color ?? this.color,
      width: width ?? this.width,
      artifacts: artifacts ?? this.artifacts,
    );
  }

  @override
  List<Object> get props => [color, width, artifacts];
}
