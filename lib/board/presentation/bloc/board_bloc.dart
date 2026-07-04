import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';
import 'package:julia_board/board/domain/repository/board_repository_interface.dart';

part 'board_event.dart';
part 'board_state.dart';
part 'board_constants.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc({
    required this.boardRepository,
  }) : super(BoardState(color: BoardConstants.colors.first)) {
    on<ColorChanged>(_onColorChanged);
    on<WidthChanged>(_onWidthChanged);
    on<ArtifactAdded>(_onArtifactAdded);
    on<UndoTapped>(_onUndoTapped);
    on<BoardCleared>(_onBoardCleared);
  }

  final BoardRepository boardRepository;

  void _onColorChanged(
    ColorChanged event,
    Emitter<BoardState> emit,
  ) async {
    emit(state.copyWith(color: event.color));
  }

  void _onWidthChanged(
    WidthChanged event,
    Emitter<BoardState> emit,
  ) async {
    emit(state.copyWith(width: event.width));
  }

  void _onArtifactAdded(
    ArtifactAdded event,
    Emitter<BoardState> emit,
  ) async {
    emit(state.copyWith(artifacts: [...state.artifacts, event.artifact]));
  }

  void _onUndoTapped(
    UndoTapped event,
    Emitter<BoardState> emit,
  ) async {
    if (state.artifacts.isEmpty) return;
    emit(
      state.copyWith(
        artifacts: [...state.artifacts.take(state.artifacts.length - 1)],
      ),
    );
  }

  void _onBoardCleared(
    BoardCleared event,
    Emitter<BoardState> emit,
  ) async {
    if (state.artifacts.isEmpty) return;
    emit(state.copyWith(artifacts: const []));
  }
}
