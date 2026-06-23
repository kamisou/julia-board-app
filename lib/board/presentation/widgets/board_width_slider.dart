import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';
import 'package:julia_board/board/presentation/data/board_constants.dart';

class BoardWidthSlider extends StatelessWidget {
  const BoardWidthSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardBloc, BoardState>(
      buildWhen: (previous, current) => previous.width != current.width,
      builder: (context, state) => RotatedBox(
        quarterTurns: 3,
        child: Slider(
          min: BoardConstants.minWidth,
          max: BoardConstants.maxWidth,
          divisions: (BoardConstants.maxWidth - BoardConstants.minWidth)
              .round(),
          value: state.width,
          onChanged: (value) => context.read<BoardBloc>().add(
            WidthChanged(width: value),
          ),
        ),
      ),
    );
  }
}
