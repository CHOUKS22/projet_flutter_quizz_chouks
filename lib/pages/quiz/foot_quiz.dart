import 'package:flutter/material.dart';
import 'quiz_page.dart';

class FootQuizPage extends StatelessWidget {
  const FootQuizPage({Key? key}) : super(key: key);

  static final Map<String, List<Map<String, dynamic>>> questionsByDifficulty = {
    'Facile': [
      {
        'question': 'Quel pays a remporté la Coupe du Monde 2018 ?',
        'options': ['Brésil', 'France', 'Allemagne', 'Argentine'],
        'answer': 'France',
      },
      {
        'question': 'Combien de joueurs sur le terrain par équipe ?',
        'options': ['9', '10', '11', '12'],
        'answer': '11',
      },
      {
        'question': 'Qui est surnommé "CR7" ?',
        'options': ['Cristiano Ronaldo', 'Messi', 'Neymar', 'Mbappé'],
        'answer': 'Cristiano Ronaldo',
      },
      {
        'question': 'Quel club est basé à Barcelone ?',
        'options': ['Real Madrid', 'FC Barcelone', 'Chelsea', 'PSG'],
        'answer': 'FC Barcelone',
      },
      {
        'question': 'Quel est le surnom de l’équipe d’Italie ?',
        'options': ['Les Bleus', 'La Roja', 'La Squadra Azzurra', 'Les Lions'],
        'answer': 'La Squadra Azzurra',
      },
    ],
    'Moyen': [
      {
        'question': 'Quel joueur a marqué la main de Dieu ?',
        'options': ['Pelé', 'Maradona', 'Zidane', 'Ronaldinho'],
        'answer': 'Maradona',
      },
      {
        'question': 'Combien de temps dure un match de foot ?',
        'options': ['60 min', '90 min', '120 min', '45 min'],
        'answer': '90 min',
      },
      {
        'question': 'Quel pays a inventé le football ?',
        'options': ['Brésil', 'Angleterre', 'France', 'Italie'],
        'answer': 'Angleterre',
      },
      {
        'question': 'Qui a gagné le Ballon d’Or 2022 ?',
        'options': ['Benzema', 'Messi', 'Ronaldo', 'Modric'],
        'answer': 'Benzema',
      },
      {
        'question': 'Quel est le poste de Manuel Neuer ?',
        'options': ['Défenseur', 'Gardien', 'Attaquant', 'Milieu'],
        'answer': 'Gardien',
      },
    ],
    'Difficile': [
      {
        'question': 'Quel club a remporté le plus de Ligues des Champions ?',
        'options': ['AC Milan', 'Real Madrid', 'Liverpool', 'Bayern'],
        'answer': 'Real Madrid',
      },
      {
        'question': 'En quelle année la France a-t-elle gagné sa première Coupe du Monde ?',
        'options': ['1998', '2006', '2018', '1982'],
        'answer': '1998',
      },
      {
        'question': 'Quel joueur détient le record de buts en Coupe du Monde ?',
        'options': ['Pelé', 'Klose', 'Ronaldo', 'Mbappé'],
        'answer': 'Klose',
      },
      {
        'question': 'Quel pays a organisé la Coupe du Monde 2014 ?',
        'options': ['Brésil', 'Allemagne', 'Afrique du Sud', 'France'],
        'answer': 'Brésil',
      },
      {
        'question': 'Quel club français a gagné la Ligue 1 en 2021 ?',
        'options': ['PSG', 'Lille', 'Monaco', 'Lyon'],
        'answer': 'Lille',
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
      title: 'Quiz Foot',
      category: 'Foot',
      difficulty: difficulty,
      questions: questions,
    );
  }
}
