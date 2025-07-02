import 'package:flutter/material.dart';
import 'quiz_page.dart';

class DeveloppementWebQuizPage extends StatelessWidget {
  const DeveloppementWebQuizPage({Key? key}) : super(key: key);

  static final Map<String, List<Map<String, dynamic>>> questionsByDifficulty = {
    'Facile': [
      {
        'question': 'Quel langage est utilisé pour le style des pages web ?',
        'options': ['HTML', 'CSS', 'JavaScript', 'PHP'],
        'answer': 'CSS',
      },
      {
        'question': 'Quel balise HTML pour un lien ?',
        'options': ['<a>', '<link>', '<href>', '<url>'],
        'answer': '<a>',
      },
      {
        'question': 'Quel framework est pour Flutter ?',
        'options': ['React', 'Vue', 'Dart', 'Flutter'],
        'answer': 'Flutter',
      },
      {
        'question': 'Quel est le langage principal de Flutter ?',
        'options': ['Java', 'Kotlin', 'Dart', 'Swift'],
        'answer': 'Dart',
      },
      {
        'question': 'Quel protocole pour sécuriser un site ?',
        'options': ['HTTP', 'FTP', 'HTTPS', 'SMTP'],
        'answer': 'HTTPS',
      },
    ],
    'Moyen': [
      {
        'question': 'Quel est le rôle de JavaScript ?',
        'options': ['Mise en page', 'Interactivité', 'Stockage', 'Sécurité'],
        'answer': 'Interactivité',
      },
      {
        'question': 'Quel est le CMS le plus utilisé ?',
        'options': ['Drupal', 'WordPress', 'Joomla', 'Magento'],
        'answer': 'WordPress',
      },
      {
        'question': 'Quel format d’image est le plus léger ?',
        'options': ['PNG', 'JPG', 'GIF', 'SVG'],
        'answer': 'SVG',
      },
      {
        'question': 'Quel langage côté serveur ?',
        'options': ['HTML', 'CSS', 'PHP', 'XML'],
        'answer': 'PHP',
      },
      {
        'question': 'Quel outil pour versionner le code ?',
        'options': ['Git', 'FTP', 'SSH', 'HTTP'],
        'answer': 'Git',
      },
    ],
    'Difficile': [
      {
        'question': 'Quel port HTTP par défaut ?',
        'options': ['80', '443', '21', '22'],
        'answer': '80',
      },
      {
        'question': 'Quel langage compile en bytecode JVM ?',
        'options': ['Java', 'PHP', 'Python', 'C++'],
        'answer': 'Java',
      },
      {
        'question': 'Quel est le créateur de Linux ?',
        'options': ['Bill Gates', 'Linus Torvalds', 'Steve Jobs', 'Mark Zuckerberg'],
        'answer': 'Linus Torvalds',
      },
      {
        'question': 'Quel protocole pour envoyer des emails ?',
        'options': ['SMTP', 'FTP', 'HTTP', 'POP3'],
        'answer': 'SMTP',
      },
      {
        'question': 'Quel langage est typé dynamiquement ?',
        'options': ['C', 'Java', 'Python', 'C++'],
        'answer': 'Python',
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
      title: 'Quiz Développement Web',
      category: 'Développement web',
      difficulty: difficulty,
      questions: questions,
    );
  }
}
