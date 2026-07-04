import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';

class BoardConnectionKey extends StatelessWidget {
  const BoardConnectionKey({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BoardBloc, BoardState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.id != current.id,
      builder: (context, state) => Column(
        children: [
          Text(
            'Chave de conexão:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          AnimatedSwitcher(
            duration: Durations.short3,
            child: SizedBox(
              key: ValueKey('${state.runtimeType}_${state.id}'),
              height: 24,
              child: switch ((state.status, state.id)) {
                (BoardStatus.loading, _) => Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: const CircularProgressIndicator(
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    strokeWidth: 2,
                  ),
                ),
                (BoardStatus.error, _) || (_, null) => Text(
                  'Erro ao adquirir chave!',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 18,
                  ),
                ),
                (_, final String id) => Text(
                  id,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 18,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
