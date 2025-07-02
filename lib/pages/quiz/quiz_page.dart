import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../fonctions/database_helper.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final String category;
  final String difficulty;
  final List<Map<String, dynamic>> questions;
  const QuizPage({Key? key, required this.title, required this.category, required this.difficulty, required this.questions}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  String? selectedOption;
  int questionKey = 0;

  void checkAnswer(String option) {
    if (answered) return;
    setState(() {
      selectedOption = option;
      answered = true;
      if (option == widget.questions[currentQuestion]['answer']) {
        score++;
      }
    });
    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

  void nextQuestion() async {
    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
        answered = false;
        selectedOption = null;
        questionKey++;
      });
    } else {
      final db = DatabaseHelper();
      await db.saveQuizScore(
        userId: 1, 
        score: score,
        category: widget.category,
        difficulty: widget.difficulty,
        datePlayed: DateTime.now().toIso8601String(),
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Quiz terminé'),
          content: Text('Votre score : $score / ${widget.questions.length}\nDifficulté : ${widget.difficulty}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Color? getOptionColor(String option) {
    if (!answered) return null;
    if (option == widget.questions[currentQuestion]['answer']) {
      return Colors.green;
    }
    if (option == selectedOption) {
      return Colors.red;
    }
    return null;
  }

  Color getTextColor(String option) {
    final bg = getOptionColor(option);
    if (bg == Colors.green || bg == Colors.red) {
      return Colors.white;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[currentQuestion];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: 400.ms,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            // Animation simple : fade uniquement
            return child.animate(key: ValueKey(questionKey)).fadeIn(duration: 400.ms);
          },
          child: Column(
            key: ValueKey(questionKey),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${currentQuestion + 1} / ${widget.questions.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                q['question'],
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              ...List.generate(q['options'].length, (i) {
                final option = q['options'][i];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getOptionColor(option),
                      foregroundColor: getTextColor(option),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => checkAnswer(option),
                    child: Text(option, style: TextStyle(fontSize: 16, color: getTextColor(option))),
                  ),
                );
              }),
              const Spacer(),
              Text('Score : $score', style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
