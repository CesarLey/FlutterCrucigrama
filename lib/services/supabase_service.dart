import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://vespnopipzsllnvbnzbq.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlc3Bub3BpcHpzbGxudmJuemJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NjI5NDEsImV4cCI6MjA3NzMzODk0MX0.2ddxfqlmdivgti8hXw5e6mQR5Avg5CRZjaia7pbePtk';

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
