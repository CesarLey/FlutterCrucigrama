import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'leaderboard_dialog.dart';
import 'crossword_generator_widget.dart';
import 'crossword_puzzle_widget.dart';
import 'puzzle_completed_widget.dart';

class CrosswordPuzzleApp extends StatelessWidget {
  const CrosswordPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            _CategorySelector(),
            // Top 5 icon placed next to category and settings icons
            Consumer(builder: (context, ref, _) {
              final selectedCategory = ref.watch(selectedCategoryProvider);
              return IconButton(
                tooltip: 'Top 5',
                icon: Icon(Icons.leaderboard),
                onPressed: () => showLeaderboardDialog(context, categoryId: selectedCategory?.id, limit: 5),
              );
            }),
            SizedBox(width: 8),
            _CrosswordPuzzleAppMenu(),
          ],
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: Consumer(
            builder: (context, ref, _) {
              final selectedCategory = ref.watch(selectedCategoryProvider);
              return Text(
                selectedCategory != null
                    ? 'Crucigrama: ${selectedCategory.nameEs}'
                    : 'Crossword Puzzle',
              );
            },
          ),
        ),
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final workQueueAsync = ref.watch(workQueueProvider);
              final puzzle = ref.watch(puzzleProvider);
              final puzzleSolved = puzzle.solved;

              return workQueueAsync.when(
                data: (workQueue) {
                  if (puzzleSolved) {
                    return PuzzleCompletedWidget();
                  }
                  if (workQueue.isCompleted &&
                      workQueue.crossword.characters.isNotEmpty) {
                    return CrosswordPuzzleWidget();
                  }
                  return CrosswordGeneratorWidget();
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('$error')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

class _CategorySelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInternetAsync = ref.watch(hasInternetProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return hasInternetAsync.when(
      data: (hasInternet) {
        if (!hasInternet) {
          return Tooltip(
            message: 'Sin conexión a internet',
            child: IconButton(
              icon: Icon(Icons.wifi_off, color: Colors.grey),
              onPressed: null,
            ),
          );
        }

        return categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return IconButton(
                icon: Icon(Icons.category_outlined),
                onPressed: null,
              );
            }

            return MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () => ref.read(selectedCategoryProvider.notifier).clearCategory(),
                  leadingIcon: selectedCategory == null
                      ? Icon(Icons.radio_button_checked_outlined)
                      : Icon(Icons.radio_button_unchecked_outlined),
                  child: Text('Por defecto (todas las palabras)'),
                ),
                Divider(),
                for (final category in categories)
                  MenuItemButton(
                    onPressed: () => ref.read(selectedCategoryProvider.notifier).selectCategory(category),
                    leadingIcon: selectedCategory?.id == category.id
                        ? Icon(Icons.radio_button_checked_outlined)
                        : Icon(Icons.radio_button_unchecked_outlined),
                    child: Text(category.nameEs),
                  ),
              ],
              builder: (context, controller, child) => IconButton(
                onPressed: () => controller.open(),
                icon: Icon(
                  selectedCategory != null ? Icons.category : Icons.category_outlined,
                  color: selectedCategory != null ? Colors.green : null,
                ),
                tooltip: 'Seleccionar categoría',
              ),
            );
          },
          loading: () => IconButton(
            icon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            onPressed: null,
          ),
          error: (_, __) => IconButton(
            icon: Icon(Icons.error_outline, color: Colors.red),
            onPressed: null,
          ),
        );
      },
      loading: () => IconButton(
        icon: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        onPressed: null,
      ),
      error: (_, __) => IconButton(
        icon: Icon(Icons.wifi_off, color: Colors.grey),
        onPressed: null,
      ),
    );
  }
}

class _CrosswordPuzzleAppMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
    menuChildren: [
      for (final entry in CrosswordSize.values)
        MenuItemButton(
          onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
          leadingIcon: entry == ref.watch(sizeProvider)
              ? Icon(Icons.radio_button_checked_outlined)
              : Icon(Icons.radio_button_unchecked_outlined),
          child: Text(entry.label),
        ),
    ],
    builder: (context, controller, child) => IconButton(
      onPressed: () => controller.open(),
      icon: Icon(Icons.settings),
    ),
  );
}

