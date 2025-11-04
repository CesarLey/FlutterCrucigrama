import 'package:built_collection/built_collection.dart';

class WordCategory {
  final String id;
  final String name;
  final String nameEs;
  final BuiltSet<String> words;

  const WordCategory({
    required this.id,
    required this.name,
    required this.nameEs,
    required this.words,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) {
    final wordsData = json['words'] as List<dynamic>?;
    final wordsList = wordsData?.map((e) => e.toString()).toList() ?? [];
    
    return WordCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEs: json['name_es'] as String,
      words: BuiltSet<String>(wordsList),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_es': nameEs,
      'words': words.toList(),
    };
  }
}
