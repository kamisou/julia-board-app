part of 'board_bloc.dart';

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.width = 4.0,
    this.strokes = const [],
  });

  final Color color;
  final double width;
  final List<BoardStroke> strokes;

  BoardState copyWith({
    Color? color,
    double? width,
    List<BoardStroke>? strokes,
  }) {
    return BoardState(
      color: color ?? this.color,
      width: width ?? this.width,
      strokes: strokes ?? this.strokes,
    );
  }

  @override
  List<Object> get props => [color, width, ...strokes];
}
