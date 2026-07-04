part of 'board_bloc.dart';

sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

final class ColorChanged extends BoardEvent {
  const ColorChanged({
    required this.color,
  });

  final Color color;

  @override
  List<Object> get props => [color];
}

final class WidthChanged extends BoardEvent {
  const WidthChanged({
    required this.width,
  });

  final double width;

  @override
  List<Object> get props => [width];
}

final class ArtifactAdded extends BoardEvent {
  const ArtifactAdded({
    required this.artifact,
  });

  final BoardArtifact artifact;

  @override
  List<Object> get props => [artifact];
}

final class UndoTapped extends BoardEvent {
  const UndoTapped();
}

final class RedoTapped extends BoardEvent {
  const RedoTapped();
}

final class BoardCleared extends BoardEvent {
  const BoardCleared();
}
