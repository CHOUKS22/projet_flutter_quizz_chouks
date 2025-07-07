import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../fonctions/database_helper.dart';

import '../../models/user_model.dart';


class QuizScreen extends StatefulWidget {
  final String title;
  final String category;
  final String level;
  final List<Map<String, dynamic>> questions;
  final UserModel user;
  const QuizScreen({Key? key, required this.title, required this.category, required this.level, required this.questions, required this.user}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  int points = 0;
  bool hasAnswered = false;
  String? chosenOption;
  int qKey = 0;

  void answer(String option) {
    if (hasAnswered) return;
    setState(() {
      chosenOption = option;
      hasAnswered = true;
      if (option == widget.questions[index]['answer']) {
        points++;
      }
    });
    Future.delayed(const Duration(seconds: 1), next);
  }

  void next() async {
    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        hasAnswered = false;
        chosenOption = null;
        qKey++;
      });
    } else {
      final db = DatabaseHelper();
      await db.saveQuizScore(
        userId: widget.user.id!,
        score: points,
        category: widget.category,
        difficulty: widget.level,
        datePlayed: DateTime.now().toString(),
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Quiz terminé'),
          content: Text('Votre score : $points / ${widget.questions.length}\nDifficulté : ${widget.level}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[index];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFFF4C0C),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: 400.ms,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return child.animate(key: ValueKey(qKey)).fadeIn(duration: 400.ms);
          },
          child: Card(
            key: ValueKey(qKey),
            color: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.quiz, color: Color(0xFFFF0000), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Question ${index + 1} / ${widget.questions.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF4C0C)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    q['question'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFFF0000)),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(q['options'].length, (i) {
                    final option = q['options'][i];
                    final isCorrect = hasAnswered && option == q['answer'];
                    final isWrong = hasAnswered && option == chosenOption && option != q['answer'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          isCorrect
                              ? Icons.check_circle
                              : isWrong
                                  ? Icons.cancel
                                  : Icons.circle_outlined,
                          color: isCorrect
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.grey[400],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCorrect
                              ? Colors.green
                              : isWrong
                                  ? Colors.red
                                  : Colors.white,
                          foregroundColor: (isCorrect || isWrong)
                              ? Colors.white
                              : Colors.black,
                          side: BorderSide(
                            color: isCorrect
                                ? Colors.green
                                : isWrong
                                    ? Colors.red
                                    : Colors.grey.shade300,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () => answer(option),
                        label: Text(option, style: const TextStyle(fontSize: 16)),
                      ),
                    );
                  }),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.emoji_events, color: Color(0xFFFF4C0C)),
                      const SizedBox(width: 6),
                      Text('Score : $points', style: const TextStyle(fontSize: 18, color: Color(0xFFFF4C0C), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.home, color: Colors.deepOrange),
                        label: const Text('Accueil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepOrange,
                          side: const BorderSide(color: Colors.deepOrange),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
