import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';

class BoardControls extends StatelessWidget {
  const BoardControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: state.strokes.isNotEmpty
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
            onPressed: state.strokes.isNotEmpty
                ? () => context.read<BoardBloc>().add(const BoardCleared())
                : null,
            icon: const Icon(
              Icons.delete_rounded,
              size: 28,
            ),
          ),
          const VerticalDivider(
            indent: 8,
            endIndent: 8,
            width: 64,
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.send_rounded),
            label: const Text('Enviar'),
            style: TextButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              textStyle: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
