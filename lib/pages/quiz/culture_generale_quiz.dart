import 'package:flutter/material.dart';
import 'quiz_page.dart';

class CultureGeneraleQuizPage extends StatelessWidget {
  const CultureGeneraleQuizPage({Key? key}) : super(key: key);

  static final Map<String, List<Map<String, dynamic>>> questionsByDifficulty = {
    'Facile': [
      {'question': 'Qui a écrit "Les Misérables" ?', 'options': ['Victor Hugo', 'Molière', 'Zola', 'Balzac'], 'answer': 'Victor Hugo'},
      {'question': 'Quelle est la capitale du Canada ?', 'options': ['Toronto', 'Ottawa', 'Vancouver', 'Montréal'], 'answer': 'Ottawa'},
      {'question': 'Combien de continents sur Terre ?', 'options': ['5', '6', '7', '8'], 'answer': '7'},
      {'question': 'Quel est le plus grand océan ?', 'options': ['Atlantique', 'Indien', 'Arctique', 'Pacifique'], 'answer': 'Pacifique'},
      {'question': 'Qui a peint la Joconde ?', 'options': ['Michel-Ange', 'Raphaël', 'Léonard de Vinci', 'Monet'], 'answer': 'Léonard de Vinci'},
    ],
    'Moyen': [
      {'question': 'Quelle est la langue la plus parlée au monde ?', 'options': ['Anglais', 'Espagnol', 'Chinois', 'Arabe'], 'answer': 'Chinois'},
      {'question': 'Quel est le symbole chimique de l’eau ?', 'options': ['O2', 'CO2', 'H2O', 'HO2'], 'answer': 'H2O'},
      {'question': 'En quelle année a eu lieu la Révolution française ?', 'options': ['1789', '1848', '1914', '1492'], 'answer': '1789'},
      {'question': 'Quel est le plus long fleuve du monde ?', 'options': ['Nil', 'Amazone', 'Yangtsé', 'Mississippi'], 'answer': 'Amazone'},
      {'question': 'Qui a inventé le téléphone ?', 'options': ['Edison', 'Bell', 'Tesla', 'Newton'], 'answer': 'Bell'},
    ],
    'Difficile': [
      {'question': 'Quel est le plus haut sommet du monde ?', 'options': ['K2', 'Everest', 'Kilimandjaro', 'Mont Blanc'], 'answer': 'Everest'},
      {'question': 'Quel pays a le plus de prix Nobel de la paix ?', 'options': ['France', 'États-Unis', 'Suisse', 'Norvège'], 'answer': 'États-Unis'},
      {'question': 'Qui a découvert la pénicilline ?', 'options': ['Pasteur', 'Fleming', 'Curie', 'Einstein'], 'answer': 'Fleming'},
      {'question': 'Quel est le plus grand désert du monde ?', 'options': ['Sahara', 'Gobi', 'Antarctique', 'Kalahari'], 'answer': 'Antarctique'},
      {'question': 'Quel est le plus ancien jeu olympique ?', 'options': ['Boxe', 'Lutte', 'Course', 'Disque'], 'answer': 'Course'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Récupère la difficulté depuis les arguments de navigation, sinon "Facile"
    final args = ModalRoute.of(context)?.settings.arguments;
    final String difficulty = (args is Map && args['difficulty'] != null)
        ? args['difficulty'] as String
        : 'Facile';

    // Sélectionne la bonne liste de questions
    final questions = questionsByDifficulty[difficulty] ?? questionsByDifficulty['Facile']!;

    // Affiche la page de quiz
    return QuizPage(
      title: 'Quiz Culture Générale ($difficulty)',
      category: 'Culture générale',
      difficulty: difficulty,
      questions: questions,
    );
  }
}
