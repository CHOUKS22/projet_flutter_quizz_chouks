import 'package:flutter/material.dart';
import '../fonctions/database_helper.dart';
import '../config/router.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); 

  String selectedDifficulty = 'Facile';
  final List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];

  final List<Map<String, String>> categories = const [
    {'label': 'Foot', 'icon': 'sports_soccer'},
    {'label': 'Culture générale', 'icon': 'public'},
    {'label': 'Cuisine', 'icon': 'restaurant'},
    {'label': 'Développement web', 'icon': 'code'},
    {'label': 'Anglais', 'icon': 'translate'},
  ];

  @override
  void initState() {
    super.initState();
   
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void onCategorySelected(BuildContext context, String category, String difficulty) {
    String routeName;
    switch (category) {
      case 'Foot':
        routeName = AppRouter.quizFootRouter;
        break;
      case 'Culture générale':
        routeName = AppRouter.quizCultureGeneraleRouter;
        break;
      case 'Cuisine':
        routeName = AppRouter.quizCuisineRouter;
        break;
      case 'Développement web':
        routeName = AppRouter.quizDevWebRouter;
        break;
      case 'Anglais':
        routeName = AppRouter.quizAnglaisRouter;
        break;
      default:
        routeName = '/404';
    }
    Navigator.pushNamed(
      context,
      routeName,
      arguments: {'difficulty': difficulty},
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'public':
        return Icons.public;
      case 'restaurant':
        return Icons.restaurant;
      case 'code':
        return Icons.code;
      case 'translate':
        return Icons.translate;
      default:
        return Icons.help;
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
            icon: const Icon(Icons.logout),
            onPressed: _logout,
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
                    value: selectedDifficulty,
                    items: difficulties
                        .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text(d),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDifficulty = value;
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
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: Icon(_getIconData(cat['icon']!), color: Colors.deepOrange, size: 32),
                        title: Text(cat['label']!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepOrange),
                        onTap: () => onCategorySelected(
                          context,
                          cat['label']!,
                          selectedDifficulty,
                        ),
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
