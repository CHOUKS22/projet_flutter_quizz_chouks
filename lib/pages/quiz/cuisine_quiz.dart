import 'package:flutter/material.dart';
import 'quiz_page.dart';

class CuisineQuizPage extends StatelessWidget {
  const CuisineQuizPage({Key? key}) : super(key: key);

  static final Map<String, List<Map<String, dynamic>>> questionsByDifficulty = {
    'Facile': [
      {
        'question': 'Quel ingrédient n’est pas dans la ratatouille ?',
        'options': ['Aubergine', 'Courgette', 'Carotte', 'Poivron'],
        'answer': 'Carotte',
      },
      {
        'question': 'Quel pays est célèbre pour les sushis ?',
        'options': ['Chine', 'Japon', 'Corée', 'Thaïlande'],
        'answer': 'Japon',
      },
      {
        'question': 'Quel fromage est italien ?',
        'options': ['Brie', 'Parmesan', 'Roquefort', 'Feta'],
        'answer': 'Parmesan',
      },
      {
        'question': 'Quel plat est espagnol ?',
        'options': ['Paella', 'Pizza', 'Couscous', 'Tajine'],
        'answer': 'Paella',
      },
      {
        'question': 'Quel fruit entre dans la tarte Tatin ?',
        'options': ['Pomme', 'Poire', 'Banane', 'Fraise'],
        'answer': 'Pomme',
      },
    ],
    'Moyen': [
      {
        'question': 'Quel est le principal ingrédient du houmous ?',
        'options': ['Pois chiche', 'Lentille', 'Haricot', 'Soja'],
        'answer': 'Pois chiche',
      },
      {
        'question': 'Quel dessert est français ?',
        'options': ['Baklava', 'Tiramisu', 'Crème brûlée', 'Cheesecake'],
        'answer': 'Crème brûlée',
      },
      {
        'question': 'Quel plat est à base de poisson cru ?',
        'options': ['Sashimi', 'Ratatouille', 'Bouillabaisse', 'Cassoulet'],
        'answer': 'Sashimi',
      },
      {
        'question': 'Quel ingrédient donne la couleur au curry ?',
        'options': ['Curcuma', 'Paprika', 'Safran', 'Cumin'],
        'answer': 'Curcuma',
      },
      {
        'question': 'Quel plat est typique du Maghreb ?',
        'options': ['Couscous', 'Pizza', 'Sushi', 'Tacos'],
        'answer': 'Couscous',
      },
    ],
    'Difficile': [
      {
        'question': 'Quel fromage est à pâte persillée ?',
        'options': ['Comté', 'Roquefort', 'Emmental', 'Parmesan'],
        'answer': 'Roquefort',
      },
      {
        'question': 'Quel plat est typique du sud-ouest de la France ?',
        'options': ['Cassoulet', 'Bouillabaisse', 'Ratatouille', 'Tartiflette'],
        'answer': 'Cassoulet',
      },
      {
        'question': 'Quel fruit est utilisé dans la confiture de framboise ?',
        'options': ['Fraise', 'Framboise', 'Pomme', 'Poire'],
        'answer': 'Framboise',
      },
      {
        'question': 'Quel ingrédient donne la couleur verte au pesto ?',
        'options': ['Basilic', 'Persil', 'Menthe', 'Coriandre'],
        'answer': 'Basilic',
      },
      {
        'question': 'Quel plat est à base de semoule ?',
        'options': ['Couscous', 'Paella', 'Pizza', 'Tajine'],
        'answer': 'Couscous',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String difficulty = 'Facile';
    if (args is Map && args['difficulty'] != null) {
      difficulty = args['difficulty'] as String;
    }
    final questions = questionsByDifficulty[difficulty] ?? questionsByDifficulty['Facile']!;
    return QuizPage(
      title: 'Quiz Cuisine',
      category: 'Cuisine',
      difficulty: difficulty,
      questions: questions,
    );
  }
}
