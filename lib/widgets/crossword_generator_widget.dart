import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../model.dart';
import '../providers.dart';

class CrosswordGeneratorWidget extends ConsumerWidget {
  const CrosswordGeneratorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workQueueAsync = ref.watch(workQueueProvider);

    return Column(
      children: [
        workQueueAsync.when(
          data: (workQueue) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              workQueue.isCompleted
                  ? '✓ Generación completa - Preparando puzzle...'
                  : 'Generando: ${workQueue.crossword.words.length} palabras...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: workQueue.isCompleted ? Colors.green : Colors.blue,
              ),
            ),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Iniciando...'),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(
          child: workQueueAsync.when(
            data: (workQueue) => _CrosswordGenerator(
              crossword: workQueue.crossword,
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrosswordGenerator extends StatelessWidget {
  const _CrosswordGenerator({required this.crossword});

  final Crossword crossword;

  @override
  Widget build(BuildContext context) {
    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: _buildCell,
      columnCount: crossword.width,
      columnBuilder: (index) => _buildSpan(context, index),
      rowCount: crossword.height,
      rowBuilder: (index) => _buildSpan(context, index),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Container(
        alignment: Alignment.center,
        child: switch (crossword.characters[location]) {
          null => const SizedBox.shrink(),
          CrosswordCharacter() => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '•',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        },
      ),
    );
  }

  TableSpan _buildSpan(BuildContext context, int index) {
    return TableSpan(
      extent: FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          trailing: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
