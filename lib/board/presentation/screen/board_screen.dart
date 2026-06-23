import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/data/repository/board_repository.dart';
import 'package:julia_board/board/data/repository/board_repository_impl.dart';
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
          child: RepositoryProvider<BoardRepository>(
            create: (context) => BoardRepositoryImpl(),
            child: BlocProvider<BoardBloc>(
              create: (context) => BoardBloc(
                boardRepository: context.read<BoardRepository>(),
              ),
              child: Builder(builder: _builder),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context) {
    return BlocListener<BoardBloc, BoardState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (![BoardStatus.error, BoardStatus.success].contains(state.status)) {
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                switch (state.status) {
                  BoardStatus.error => 'Falha ao enviar desenho!',
                  BoardStatus.success => 'Desenho enviado!',
                  _ => '',
                },
              ),
            ),
          );
      },
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
    );
  }
}
