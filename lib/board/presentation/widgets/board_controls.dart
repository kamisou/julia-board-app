import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';

class BoardControls extends StatelessWidget {
  const BoardControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BoardBloc, BoardState>(
      buildWhen: (previous, current) =>
          previous.artifacts.length != current.artifacts.length,
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: state.artifacts.isNotEmpty
                ? () => context.read<BoardBloc>().add(const UndoTapped())
                : null,
            icon: const Icon(
              Icons.undo_rounded,
              size: 32,
            ),
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          IconButton.filled(
            onPressed: state.artifacts.isNotEmpty
                ? () => context.read<BoardBloc>().add(const BoardCleared())
                : null,
            icon: const Icon(
              Icons.delete_rounded,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
