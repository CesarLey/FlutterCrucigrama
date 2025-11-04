import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'services/supabase_service.dart';
import 'widgets/crossword_puzzle_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  try {
    await SupabaseService.initialize();
  } catch (e) {
    print('Error inicializando Supabase: $e');
    // Continuar sin Supabase (modo offline)
  }
  
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Crossword Puzzle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        home: const CrosswordPuzzleApp(),
      ),
    ),
  );
}
