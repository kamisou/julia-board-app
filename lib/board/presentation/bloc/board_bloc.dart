import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:julia_board/board/data/repository/board_repository.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';

part 'board_event.dart';
part 'board_state.dart';
part 'board_constants.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc({
    required this.boardRepository,
  }) : super(BoardState(color: BoardConstants.colors.first)) {
    on<BoardStarted>(_onBoardStarted);
    on<ColorChanged>(_onColorChanged);
    on<WidthChanged>(_onWidthChanged);
    on<ArtifactAdded>(_onArtifactAdded);
    on<UndoTapped>(_onUndoTapped);
    on<RedoTapped>(_onRedoTapped);
    on<BoardCleared>(_onBoardCleared);
  }

  final BoardRepository boardRepository;

  Future<void> _onBoardStarted(
    BoardStarted event,
    Emitter<BoardState> emit,
  ) async {
    final artifacts = await boardRepository.restoreBoard();
    emit(state.copyWith(artifacts: artifacts));
  }

  void _onColorChanged(
    ColorChanged event,
    Emitter<BoardState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _onWidthChanged(
    WidthChanged event,
    Emitter<BoardState> emit,
  ) {
    emit(state.copyWith(width: event.width));
  }

  Future<void> _onArtifactAdded(
    ArtifactAdded event,
    Emitter<BoardState> emit,
  ) async {
    if (state.artifacts.length > BoardConstants.maxArtifacts) return;
    emit(
      state.copyWith(
        artifacts: [...state.artifacts, event.artifact],
        undoBuffer: const [],
      ),
    );
    return boardRepository.addArtifact(event.artifact);
  }

  void _onUndoTapped(
    UndoTapped event,
    Emitter<BoardState> emit,
  ) async {
    if (state.artifacts.isEmpty) return;
    await boardRepository.removeArtifact(state.artifacts.last);
    emit(
      state.copyWith(
        artifacts: [...state.artifacts.take(state.artifacts.length - 1)],
        undoBuffer: [...state.undoBuffer, state.artifacts.last],
      ),
    );
  }

  void _onRedoTapped(
    RedoTapped event,
    Emitter<BoardState> emit,
  ) async {
    if (state.undoBuffer.isEmpty) return;
    await boardRepository.addArtifact(state.undoBuffer.last);
    emit(
      state.copyWith(
        artifacts: [...state.artifacts, state.undoBuffer.last],
        undoBuffer: [...state.undoBuffer.take(state.undoBuffer.length - 1)],
      ),
    );
  }

  void _onBoardCleared(
    BoardCleared event,
    Emitter<BoardState> emit,
  ) async {
    if (state.artifacts.isEmpty) return;
    emit(state.copyWith(artifacts: const [], undoBuffer: const []));
    await boardRepository.clearBoard();
  }
}
