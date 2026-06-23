import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:julia_board/board/data/repository/board_repository.dart';
import 'package:julia_board/board/presentation/data/board_constants.dart';
import 'package:julia_board/board/presentation/data/board_stroke.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc({
    required this.boardRepository,
  }) : super(BoardState(color: BoardConstants.colors.first)) {
    on<ColorChanged>(_onColorChanged);
    on<WidthChanged>(_onWidthChanged);
    on<StrokeAdded>(_onStrokeAdded);
    on<UndoTapped>(_onUndoTapped);
    on<BoardCleared>(_onBoardCleared);
    on<BoardSent>(_onBoardSent);
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

  void _onStrokeAdded(
    StrokeAdded event,
    Emitter<BoardState> emit,
  ) async {
    emit(state.copyWith(strokes: [...state.strokes, event.stroke]));
  }

  void _onUndoTapped(
    UndoTapped event,
    Emitter<BoardState> emit,
  ) async {
    if (state.strokes.isEmpty) return;
    emit(
      state.copyWith(
        strokes: [...state.strokes.take(state.strokes.length - 1)],
      ),
    );
  }

  void _onBoardCleared(
    BoardCleared event,
    Emitter<BoardState> emit,
  ) async {
    if (state.strokes.isEmpty) return;
    emit(state.copyWith(strokes: const []));
  }

  Future<void> _onBoardSent(
    BoardSent event,
    Emitter<BoardState> emit,
  ) async {
    emit(state.copyWith(status: BoardStatus.loading));
    try {
      await boardRepository.sendBoard(state.strokes);
      emit(state.copyWith(strokes: const [], status: BoardStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BoardStatus.error));
    }
  }
}
