import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isolates.dart';
import 'model.dart' as model;
import 'models/category.dart';
import 'services/connectivity_service.dart';
import 'services/supabase_service.dart';

part 'providers.g.dart';

const backgroundWorkerCount = 4;

/// A provider for the wordlist to use when generating the crossword.
@riverpod
Future<BuiltSet<String>> wordList(WordListRef ref) async {
  // This codebase requires that all words consist of lowercase characters
  // in the range 'a'-'z'. Words containing uppercase letters will be
  // lowercased, and words containing runes outside this range will
  // be removed.

  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');
  return const LineSplitter()
      .convert(words)
      .toBuiltSet()
      .rebuild(
        (b) => b
          ..map((word) => word.toLowerCase().trim())
          ..where((word) => word.length > 2)
          ..where((word) => re.hasMatch(word)),
      );
}

/// An enumeration for different sizes of [model.Crossword]s.
enum CrosswordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrosswordSize({required this.width, required this.height});

  final int width;
  final int height;
  String get label => '$width x $height';
}

/// A provider that holds the current size of the crossword to generate.
@Riverpod(keepAlive: true)
class Size extends _$Size {
  var _size = CrosswordSize.small;

  @override
  CrosswordSize build() => _size;

  void setSize(CrosswordSize size) {
    _size = size;
    ref.invalidateSelf();
  }
}

@riverpod
Stream<model.WorkQueue> workQueue(WorkQueueRef ref) async* {
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(categoryWordListProvider);
  final emptyCrossword = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );
  final emptyWorkQueue = model.WorkQueue.from(
    crossword: emptyCrossword,
    candidateWords: BuiltSet<String>(),
    startLocation: model.Location.at(0, 0),
  );

  yield* wordListAsync.when(
    data: (wordList) => exploreCrosswordSolutions(
      crossword: emptyCrossword,
      wordList: wordList,
      maxWorkerCount: backgroundWorkerCount,
    ),
    error: (error, stackTrace) async* {
      debugPrint('Error loading word list: $error');
      yield emptyWorkQueue;
    },
    loading: () async* {
      yield emptyWorkQueue;
    },
  );
}

@Riverpod(keepAlive: true)
class Puzzle extends _$Puzzle {
  model.CrosswordPuzzleGame _puzzle = model.CrosswordPuzzleGame.from(
    crossword: model.Crossword.crossword(width: 0, height: 0),
    candidateWords: BuiltSet<String>(),
  );

  @override
  model.CrosswordPuzzleGame build() {
    final size = ref.watch(sizeProvider);
    final wordList = ref.watch(categoryWordListProvider).value;
    final workQueue = ref.watch(workQueueProvider).value;

    if (wordList != null &&
        workQueue != null &&
        workQueue.isCompleted &&
        (_puzzle.crossword.height != size.height ||
            _puzzle.crossword.width != size.width ||
            _puzzle.crossword != workQueue.crossword)) {
      compute(_puzzleFromCrosswordTrampoline, (
        workQueue.crossword,
        wordList,
      )).then((puzzle) {
        _puzzle = puzzle;
        ref.invalidateSelf();
      });
    }

    return _puzzle;
  }

  Future<void> selectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) async {
    final candidate = await compute(_puzzleSelectWordTrampoline, (
      _puzzle,
      location,
      word,
      direction,
    ));

    if (candidate != null) {
      _puzzle = candidate;
      ref.invalidateSelf();
    } else {
      debugPrint('Invalid word selection: $word');
    }
  }

  bool canSelectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) {
    return _puzzle.canSelectWord(
      location: location,
      word: word,
      direction: direction,
    );
  }
}

// Trampoline functions to disentangle these Isolate target calls from the
// unsendable reference to the [Puzzle] provider.

Future<model.CrosswordPuzzleGame> _puzzleFromCrosswordTrampoline(
  (model.Crossword, BuiltSet<String>) args,
) async =>
    model.CrosswordPuzzleGame.from(crossword: args.$1, candidateWords: args.$2);

model.CrosswordPuzzleGame? _puzzleSelectWordTrampoline(
  (model.CrosswordPuzzleGame, model.Location, String, model.Direction) args,
) => args.$1.selectWord(location: args.$2, word: args.$3, direction: args.$4);

// ==================== CONNECTIVITY & CATEGORIES ====================

/// Provider que verifica si hay conexión a internet
@riverpod
Future<bool> hasInternet(HasInternetRef ref) async {
  return await ConnectivityService.hasInternetConnection();
}

/// Provider que obtiene las categorías disponibles desde Supabase
@riverpod
Future<List<WordCategory>> categories(CategoriesRef ref) async {
  final hasInternet = await ref.watch(hasInternetProvider.future);
  
  if (!hasInternet) {
    return [];
  }

  try {
    return await SupabaseService.getCategories();
  } catch (e) {
    debugPrint('Error loading categories: $e');
    return [];
  }
}

/// Provider que mantiene la categoría seleccionada actualmente
@Riverpod(keepAlive: true)
class SelectedCategory extends _$SelectedCategory {
  WordCategory? _category;

  @override
  WordCategory? build() => _category;

  void selectCategory(WordCategory? category) {
    _category = category;
    ref.invalidateSelf();
    // Invalidar el workQueue para regenerar con la nueva categoría
    ref.invalidate(workQueueProvider);
  }

  void clearCategory() {
    _category = null;
    ref.invalidateSelf();
    ref.invalidate(workQueueProvider);
  }
}

/// Provider modificado del wordList que considera la categoría seleccionada
@riverpod
Future<BuiltSet<String>> categoryWordList(CategoryWordListRef ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  // Si hay una categoría seleccionada, usar sus palabras
  if (selectedCategory != null) {
    return selectedCategory.words;
  }
  
  // Si no, usar la lista de palabras por defecto
  return await ref.watch(wordListProvider.future);
}

