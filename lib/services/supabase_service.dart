import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://kmkhyipsxuwmusuvthyp.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtta2h5aXBzeHV3bXVzdXZ0aHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDUzODMsImV4cCI6MjA3NzMyMTM4M30.H6hc8gakOP_oIHxycBqYHtDNq0GyDi3nrrL3KQRh9dg';

  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase no ha sido inicializado. Llama a initialize() primero.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// Obtiene todas las categorías de palabras desde Supabase
  static Future<List<WordCategory>> getCategories() async {
    try {
      final response = await client
          .from('word_categories')
          .select()
          .order('name_es');

      final categories = (response as List)
          .map((json) => WordCategory.fromJson(json))
          .toList();

      return categories;
    } catch (e) {
      print('Error obteniendo categorías: $e');
      return [];
    }
  }

  /// Obtiene una categoría específica por ID
  static Future<WordCategory?> getCategoryById(String id) async {
    try {
      final response = await client
          .from('word_categories')
          .select()
          .eq('id', id)
          .single();

      return WordCategory.fromJson(response);
    } catch (e) {
      print('Error obteniendo categoría: $e');
      return null;
    }
  }

  /// Guarda un crucigrama generado en Supabase
  static Future<bool> saveCrossword({
    required String categoryId,
    required Map<String, dynamic> crosswordData,
  }) async {
    try {
      await client.from('saved_crosswords').insert({
        'category_id': categoryId,
        'crossword_data': crosswordData,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error guardando crucigrama: $e');
      return false;
    }
  }

  /// Guarda una puntuación (score) en la tabla `saved_crosswords`.
  /// Se reutiliza la tabla `saved_crosswords` guardando la información de
  /// jugador y puntuación dentro de `crossword_data`.
  static Future<bool> saveScore({
    String? categoryId,
    required String playerName,
    required int score,
    required List<String> words,
  }) async {
    try {
      await client.from('saved_crosswords').insert({
        'category_id': categoryId,
        'crossword_data': {
          'player_name': playerName,
          'score': score,
          'words': words,
        },
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error guardando puntuación: $e');
      return false;
    }
  }

  

  /// Guarda una puntuación en la tabla `gamescores` (tabla dedicada creada por el script SQL).
  static Future<bool> saveScoreRecord({
    String? categoryId,
    required String playerName,
    required int score,
    required List<String> words,
  }) async {
    try {
  await client.from('GameScores').insert({
        'player_name': playerName,
        'category_id': categoryId,
        'score': score,
        'words': words,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error guardando registro de puntuación: $e');
      return false;
    }
  }

  /// Obtiene los top N scores (por defecto top 10) opcionalmente filtrando por categoría.
  static Future<List<Map<String, dynamic>>> getTopScores({
    String? categoryId,
    int limit = 10,
  }) async {
    try {
      List response;
      if (categoryId == null) {
    response = await client
      .from('GameScores')
            .select()
            .order('score', ascending: false)
            .limit(limit);
      } else {
    response = await client
      .from('GameScores')
            .select()
            .eq('category_id', categoryId)
            .order('score', ascending: false)
            .limit(limit);
      }
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obteniendo top scores: $e');
      return [];
    }
  }

  /// Obtiene crucigramas guardados de una categoría
  static Future<List<Map<String, dynamic>>> getSavedCrosswords(
      String categoryId) async {
    try {
      final response = await client
          .from('saved_crosswords')
          .select()
          .eq('category_id', categoryId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obteniendo crucigramas guardados: $e');
      return [];
    }
  }
}
