part of 'board_bloc.dart';

enum BoardStatus { initial, loading, success, error }

final class BoardState extends Equatable {
  const BoardState({
    required this.color,
    this.width = 4.0,
    this.strokes = const [],
    this.status = BoardStatus.initial,
  });

  final Color color;
  final double width;
  final List<BoardStroke> strokes;
  final BoardStatus status;

  BoardState copyWith({
    Color? color,
    double? width,
    List<BoardStroke>? strokes,
    BoardStatus? status,
  }) {
    return BoardState(
      color: color ?? this.color,
      width: width ?? this.width,
      strokes: strokes ?? this.strokes,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [color, width, ...strokes, status];
}
