// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListHash() => r'8e3e9cd4555ba4baa045ccddd8dd45a25cfb6653';

/// A provider for the wordlist to use when generating the crossword.
///
/// Copied from [wordList].
@ProviderFor(wordList)
final wordListProvider = AutoDisposeFutureProvider<BuiltSet<String>>.internal(
  wordList,
  name: r'wordListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$workQueueHash() => r'0c5c8904ff41e4a3f1c1894102a51fe225900ec3';

/// See also [workQueue].
@ProviderFor(workQueue)
final workQueueProvider = AutoDisposeStreamProvider<model.WorkQueue>.internal(
  workQueue,
  name: r'workQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkQueueRef = AutoDisposeStreamProviderRef<model.WorkQueue>;
String _$hasInternetHash() => r'eaf90340ebe8d2495f620d796d261a9c7e9532b2';

/// Provider que verifica si hay conexión a internet
///
/// Copied from [hasInternet].
@ProviderFor(hasInternet)
final hasInternetProvider = AutoDisposeFutureProvider<bool>.internal(
  hasInternet,
  name: r'hasInternetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasInternetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasInternetRef = AutoDisposeFutureProviderRef<bool>;
String _$categoriesHash() => r'f66e2b3919ccc7150e006e5c5b2e45befb430694';

/// Provider que obtiene las categorías disponibles desde Supabase
///
/// Copied from [categories].
@ProviderFor(categories)
final categoriesProvider =
    AutoDisposeFutureProvider<List<WordCategory>>.internal(
      categories,
      name: r'categoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<WordCategory>>;
String _$categoryWordListHash() => r'0cc28d749e71e694ec4d09f88c894e0ab5cc5865';

/// Provider modificado del wordList que considera la categoría seleccionada
///
/// Copied from [categoryWordList].
@ProviderFor(categoryWordList)
final categoryWordListProvider =
    AutoDisposeFutureProvider<BuiltSet<String>>.internal(
      categoryWordList,
      name: r'categoryWordListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryWordListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryWordListRef = AutoDisposeFutureProviderRef<BuiltSet<String>>;
String _$sizeHash() => r'6ece68b4e628680963f11e0885d044cfa64b18fc';

/// A provider that holds the current size of the crossword to generate.
///
/// Copied from [Size].
@ProviderFor(Size)
final sizeProvider = NotifierProvider<Size, CrosswordSize>.internal(
  Size.new,
  name: r'sizeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Size = Notifier<CrosswordSize>;
String _$puzzleHash() => r'4d88f30d8ab58e84099913c73628ba5d2e8f4ca0';

/// See also [Puzzle].
@ProviderFor(Puzzle)
final puzzleProvider =
    NotifierProvider<Puzzle, model.CrosswordPuzzleGame>.internal(
      Puzzle.new,
      name: r'puzzleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$puzzleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Puzzle = Notifier<model.CrosswordPuzzleGame>;
String _$selectedCategoryHash() => r'cba542b4a62c6fa710b8d49efb3ab6e8cb389510';

/// Provider que mantiene la categoría seleccionada actualmente
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, WordCategory?>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = Notifier<WordCategory?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
