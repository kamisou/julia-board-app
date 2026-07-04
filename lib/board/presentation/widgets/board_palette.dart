import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';

class BoardPalette extends StatelessWidget {
  const BoardPalette({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardBloc, BoardState>(
      buildWhen: (previous, current) => previous.color != current.color,
      builder: (context, state) => Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final color in BoardConstants.colors)
            _colorCircle(context, state, color),
        ],
      ),
    );
  }

  Widget _colorCircle(BuildContext context, BoardState state, Color color) {
    final selected = state.color == color;
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.read<BoardBloc>().add(
        ColorChanged(color: color),
      ),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Center(
          child: AnimatedContainer(
            curve: Curves.elasticOut,
            duration: Durations.extralong4,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                  color: theme.colorScheme.shadow.withAlpha(64),
                ),
              ],
              color: color,
              shape: BoxShape.circle,
            ),
            width: selected ? 52 : 36,
            height: selected ? 52 : 36,
          ),
        ),
      ),
    );
  }
}
