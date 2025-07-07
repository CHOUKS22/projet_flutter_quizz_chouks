import 'package:flutter/material.dart';
import '../fonctions/database_helper.dart';
import '../config/router.dart';
import '../models/user_model.dart';


class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper();
  String selectedLevel = 'Facile';
  final List<String> levels = ['Facile', 'Moyen', 'Difficile'];
  List<String> categoryList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => loading = true);
    final cats = await db.getAllCategories();
    setState(() {
      categoryList = cats;
      loading = false;
    });
  }

  void logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AppRouter.loginRouter);
            },
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }

  Future<void> startQuiz(String category, String level) async {
    try {
      final questions = await db.getQuestionsByCategoryAndDifficulty(category, level);
      if (!mounted) return;
      if (questions.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Aucune question'),
            content: const Text('Aucune question trouvée pour cette catégorie et difficulté.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      Navigator.pushNamed(
        context,
        AppRouter.quizRouter,
        arguments: {
          'title': 'Quiz $category',
          'category': category,
          'difficulty': level,
          'questions': questions,
          'user': widget.user,
        },
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Erreur'),
          content: Text('Erreur lors de la récupération des questions :\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/app_icon.png', height: 32),
            const SizedBox(width: 10),
            const Text('Firequizz', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRouter.adminAddQuestionRouter,
              arguments: widget.user,
            ),
            tooltip: 'Admin: Ajouter une question',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepOrange.shade100,
                      child: const Icon(Icons.person, color: Colors.deepOrange),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(widget.user.email, style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('Voir l\'historique des scores'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.historyRouter,
                  arguments: widget.user,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Choisissez une difficulté :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepOrange.shade100),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLevel,
                  items: levels
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLevel = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choisissez une catégorie :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : categoryList.isEmpty
                      ? const Center(child: Text('Aucune catégorie disponible'))
                      : ListView.separated(
                          itemCount: categoryList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final cat = categoryList[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: const Icon(Icons.category, color: Colors.deepOrange, size: 32),
                                title: Text(cat, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrange),
                                onTap: () => startQuiz(cat, selectedLevel),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
