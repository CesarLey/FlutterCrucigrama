import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../services/supabase_service.dart';

class PuzzleCompletedWidget extends ConsumerStatefulWidget {
  const PuzzleCompletedWidget({super.key});

  @override
  ConsumerState<PuzzleCompletedWidget> createState() => _PuzzleCompletedWidgetState();
}

class _PuzzleCompletedWidgetState extends ConsumerState<PuzzleCompletedWidget> {
  final TextEditingController _nameController = TextEditingController();
  bool _saving = false;
  bool _saved = false;
  VoidCallback? _nameListener;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el campo de nombre para actualizar el estado
    _nameListener = () {
      if (mounted) setState(() {});
    };
    _nameController.addListener(_nameListener!);
  }

  @override
  void dispose() {
    // Remover listener y disponer el controlador.
    if (_nameListener != null) {
      _nameController.removeListener(_nameListener!);
      _nameListener = null;
    }
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);

    final puzzle = ref.read(puzzleProvider);
    final selectedCategory = ref.read(selectedCategoryProvider);

    final int score = puzzle.selectedWords.length;
    final words = puzzle.selectedWords.map((w) => w.word).toList();

    final success = await SupabaseService.saveScoreRecord(
      categoryId: selectedCategory?.id,
      playerName: name,
      score: score,
      words: words,
    );

    if (!mounted) return;

    setState(() {
      _saving = false;
      _saved = success;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Puntuación guardada' : 'Error guardando puntuación'),
      ),
    );
  }

  // _showTop5 removed: AppBar now exposes the unified leaderboard dialog.

  @override
  Widget build(BuildContext context) {
    final puzzle = ref.watch(puzzleProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final int score = puzzle.selectedWords.length;
    final words = puzzle.selectedWords.map((w) => w.word).toList();
    // Evitar overflow en portrait y landscape cuando el teclado aparece.
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final orientation = MediaQuery.of(context).orientation;

          // En landscape reservamos menos altura para la tarjeta (deja espacio para teclados flotantes)
          final fraction = orientation == Orientation.landscape ? 0.66 : 0.85;
          final cardMaxHeight = (constraints.maxHeight * fraction) - bottomInset - 16;
          final cardWidth = constraints.maxWidth > 700 ? 700.0 : constraints.maxWidth * 0.96;

          return Stack(
            children: [
              // Contenido principal desplazable
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset, top: 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardWidth),
                    child: Card(
                      elevation: 6,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          // La tarjeta nunca excederá `cardMaxHeight`, permitiendo scroll interno si el contenido
                          // supera este valor. También dejamos un mínimo razonable.
                          maxHeight: cardMaxHeight.clamp(220.0, constraints.maxHeight),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '¡Crucigrama completado! 🎉',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Categoría: ${selectedCategory?.nameEs ?? 'Por defecto'}', textAlign: TextAlign.center),
                                const SizedBox(height: 8),
                                Text('Palabras encontradas: $score', textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                if (words.isNotEmpty) ...[
                                  Text('Palabras:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  // La lista de palabras se limita a una fracción del espacio de la tarjeta
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: (cardMaxHeight * 0.25).clamp(60.0, 220.0),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: words.map((w) => Chip(label: Text(w))).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Tu nombre',
                                    hintText: 'Escribe tu nombre para guardar la puntuación',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _saving || _saved || _nameController.text.trim().isEmpty
                                            ? null
                                            : () => _saveScore(),
                                        icon: _saving
                                            ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                            : Icon(Icons.save),
                                        label: Text(_saved ? 'Guardado' : 'Guardar puntuación'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    ref.invalidate(workQueueProvider);
                                    ref.invalidate(puzzleProvider);
                                  },
                                  child: Text('Jugar otra vez'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // (Botón Top 5 movido al AppBar) - eliminado aquí para evitar duplicados.
            ],
          );
        },
      ),
    );
  }
}
