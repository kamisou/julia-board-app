import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';
import 'package:julia_board/board/presentation/widgets/board_controls.dart';
import 'package:julia_board/board/presentation/widgets/board_palette.dart';
import 'package:julia_board/board/presentation/widgets/board_widget.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: BlocProvider<BoardBloc>(
            create: (context) => BoardBloc(),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BoardWidget(),
                SizedBox(height: 32),
                BoardPalette(),
                SizedBox(height: 16),
                IntrinsicHeight(child: BoardControls()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
