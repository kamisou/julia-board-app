import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';

class BoardControls extends StatelessWidget {
  const BoardControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        IconButton(
          onPressed: () => context.read<BoardBloc>().add(const UndoTapped()),
          icon: const Icon(Icons.undo_rounded),
        ),
        IconButton.filled(
          onPressed: () => context.read<BoardBloc>().add(const BoardCleared()),
          icon: const Icon(Icons.delete_rounded),
        ),
        const VerticalDivider(
          indent: 8,
          endIndent: 8,
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share_rounded),
          label: const Text('Compartilhar'),
        ),
      ],
    );
  }
}
