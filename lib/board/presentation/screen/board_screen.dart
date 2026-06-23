import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';
import 'package:julia_board/board/presentation/widgets/board_controls.dart';
import 'package:julia_board/board/presentation/widgets/board_palette.dart';
import 'package:julia_board/board/presentation/widgets/board_widget.dart';
import 'package:julia_board/board/presentation/widgets/board_width_slider.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: BlocProvider<BoardBloc>(
            create: (context) => BoardBloc(),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 32,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BoardWidget(),
                ),
                Row(
                  spacing: 16,
                  children: [
                    BoardWidthSlider(),
                    Expanded(child: BoardPalette()),
                  ],
                ),
                IntrinsicHeight(child: BoardControls()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
