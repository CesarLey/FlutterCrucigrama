import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

/// Muestra un diálogo estilizado con el Top N scores (por defecto 5).
/// Puedes pasar categoryId para filtrar por categoría.
Future<void> showLeaderboardDialog(BuildContext context, {String? categoryId, int limit = 5}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Top $limit jugadores'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: SupabaseService.getTopScores(categoryId: categoryId, limit: limit),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error al cargar scores'));
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) return Center(child: Text('Aún no hay puntuaciones.'));

              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 8),
                padding: EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final row = items[index];
                  final name = (row['player_name'] ?? 'Anon').toString();
                  final score = row['score']?.toString() ?? '0';
                  final created = row['created_at'];
                  String datePart = '';
                  String timePart = '';
                  try {
                    if (created != null) {
                      final dt = DateTime.parse(created.toString()).toLocal();
                      final d = dt.toIso8601String().split('T').first;
                      final t = dt.toLocal().toString().split(' ').last.split('.').first;
                      datePart = d;
                      timePart = t;
                    }
                  } catch (_) {}

                  Color medalColor;
                  switch (index) {
                    case 0:
                      medalColor = Color(0xFFFFD700); // oro
                      break;
                    case 1:
                      medalColor = Color(0xFFC0C0C0); // plata
                      break;
                    case 2:
                      medalColor = Color(0xFFCD7F32); // bronce
                      break;
                    default:
                      medalColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);
                  }

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [medalColor.withOpacity(0.9), medalColor.withOpacity(0.6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                if (datePart.isNotEmpty)
                                  Text(datePart, style: TextStyle(fontSize: 12, color: Colors.black54)),
                                if (timePart.isNotEmpty)
                                  Text(timePart, style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Chip(
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              label: Text(score, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cerrar')),
        ],
      );
    },
  );
}
