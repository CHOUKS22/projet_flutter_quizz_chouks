import 'package:flutter/material.dart';
import 'quiz_page.dart';

class AnglaisQuizPage extends StatelessWidget {
  const AnglaisQuizPage({Key? key}) : super(key: key);

  static final Map<String, List<Map<String, dynamic>>> questionsByDifficulty = {
    'Facile': [
      {'question': 'How do you say "chien" in English?', 'options': ['Cat', 'Dog', 'Horse', 'Bird'], 'answer': 'Dog'},
      {'question': 'What is the past tense of "go"?', 'options': ['Goed', 'Went', 'Go', 'Gone'], 'answer': 'Went'},
      {'question': 'Translate: "Bonjour"', 'options': ['Goodbye', 'Hello', 'Please', 'Thanks'], 'answer': 'Hello'},
      {'question': 'Which is a color?', 'options': ['Apple', 'Blue', 'Table', 'Run'], 'answer': 'Blue'},
      {'question': 'What is the plural of "child"?', 'options': ['Childs', 'Children', 'Childes', 'Child'], 'answer': 'Children'},
    ],
    'Moyen': [
      {'question': 'How do you say "merci" in English?', 'options': ['Sorry', 'Please', 'Thank you', 'Hello'], 'answer': 'Thank you'},
      {'question': 'Which word is a verb?', 'options': ['Run', 'Blue', 'Table', 'Apple'], 'answer': 'Run'},
      {'question': 'What is the opposite of "hot"?', 'options': ['Cold', 'Warm', 'Cool', 'Heat'], 'answer': 'Cold'},
      {'question': 'How do you say "livre" in English?', 'options': ['Book', 'Pen', 'Table', 'Chair'], 'answer': 'Book'},
      {'question': 'Which is a day of the week?', 'options': ['January', 'Monday', 'Summer', 'Night'], 'answer': 'Monday'},
    ],
    'Difficile': [
      {'question': 'What is the synonym of "happy"?', 'options': ['Sad', 'Angry', 'Joyful', 'Tired'], 'answer': 'Joyful'},
      {'question': 'What is the antonym of "difficult"?', 'options': ['Easy', 'Hard', 'Long', 'Short'], 'answer': 'Easy'},
      {'question': 'How do you say "pomme" in English?', 'options': ['Apple', 'Banana', 'Pear', 'Peach'], 'answer': 'Apple'},
      {'question': 'What is the past participle of "eat"?', 'options': ['Eaten', 'Ate', 'Eat', 'Eating'], 'answer': 'Eaten'},
      {'question': 'Which is a preposition?', 'options': ['On', 'Run', 'Blue', 'Eat'], 'answer': 'On'},
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
      title: 'Quiz Anglais',
      category: 'Anglais',
      difficulty: difficulty,
      questions: questions,
    );
  }
}
