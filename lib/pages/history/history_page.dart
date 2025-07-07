import 'package:flutter/material.dart';
import '../../fonctions/database_helper.dart';
import '../../models/score_model.dart';
import '../../models/user_model.dart';

class HistoryPage extends StatefulWidget {
  final UserModel user;
  const HistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ScoreModel> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    if (widget.user.id != null) {
      final data = await DatabaseHelper().getScoresByUser(widget.user.id!);
      setState(() {
        _scores = data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _scores = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des scores')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scores.isEmpty
              ? const Center(child: Text('Aucun score enregistré.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scores.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final s = _scores[index];
                    return ListTile(
                      leading: const Icon(Icons.emoji_events),
                      title: Row(
                        children: [
                          Expanded(child: Text('${s.category} - ${s.score} pts')),
                          Chip(
                            label: Text(s.difficulty),
                            backgroundColor: s.difficulty == 'Facile'
                                ? Colors.green[100]
                                : s.difficulty == 'Moyen'
                                    ? Colors.orange[100]
                                    : Colors.red[100],
                            labelStyle: TextStyle(
                              color: s.difficulty == 'Facile'
                                  ? Colors.green[900]
                                  : s.difficulty == 'Moyen'
                                      ? Colors.orange[900]
                                      : Colors.red[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text('Date: ${s.datePlayed}'),
                    );
                  },
                ),
    );
  }
}
