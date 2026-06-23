part of 'board_bloc.dart';

final class BoardColors {
  static final colors = [
    const Color(0xFF000000),
    const Color(0xFFFFFFFF),
    const Color(0xFFE53935),
    const Color(0xFFD81B60),
    const Color(0xFF8E24AA),
    const Color(0xFF5E35B1),
    const Color(0xFF3949AB),
    const Color(0xFF1E88E5),
    const Color(0xFF039BE5),
    const Color(0xFF00ACC1),
    const Color(0xFF00897B),
    const Color(0xFF43A047),
    const Color(0xFF7CB342),
    const Color(0xFFC0CA33),
    const Color(0xFFFDD835),
    const Color(0xFFFFB300),
    const Color(0xFFFB8C00),
    const Color(0xFFF4511E),
    const Color(0xFF6D4C41),
    const Color(0xFF757575),
    const Color(0xFF546E7A),
    const Color(0xFFAD1457),
    const Color(0xFF00695C),
    const Color(0xFF9E9D24),
  ];
}

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
