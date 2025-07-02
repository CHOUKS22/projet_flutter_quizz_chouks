// Gestion des routes/navigation pour l'application

import 'package:flutter/material.dart';
import '../pages/forms/login.dart';
import '../pages/forms/register.dart';
import '../home_page.dart';
import '../pages/quiz/foot_quiz.dart';
import '../pages/quiz/culture_generale_quiz.dart';
import '../pages/quiz/cuisine_quiz.dart';
import '../pages/quiz/developpement_web_quiz.dart';
import '../pages/quiz/anglais_quiz.dart';
import '../pages/history/history_page.dart';
import '../models/user_model.dart';

// Classe pour gérer le routage de l'application Quiz
class AppRouter {
  static const String rootRouter = '/';
  static const String loginRouter = '/login';
  static const String registerRouter = '/register';
  static const String homePageRouter = '/home';
  static const String quizFootRouter = '/quiz/foot';
  static const String quizCultureGeneraleRouter = '/quiz/culture_generale';
  static const String quizCuisineRouter = '/quiz/cuisine';
  static const String quizDevWebRouter = '/quiz/developpement_web';
  static const String quizAnglaisRouter = '/quiz/anglais';
  static const String historyRouter = '/history';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRouter:
        return MaterialPageRoute(builder: (_) => LoginForm());
      case loginRouter:
        return MaterialPageRoute(builder: (_) => LoginForm());
      case registerRouter:
        return MaterialPageRoute(builder: (_) => RegisterForm());
      case homePageRouter:
        return MaterialPageRoute(builder: (_) => HomePage(user: settings.arguments as UserModel));
      case quizFootRouter:
        return MaterialPageRoute(
          builder: (_) => const FootQuizPage(),
          settings: settings,
        );
      case quizCultureGeneraleRouter:
        return MaterialPageRoute(
          builder: (_) => const CultureGeneraleQuizPage(),
          settings: settings,
        );
      case quizCuisineRouter:
        return MaterialPageRoute(
          builder: (_) => const CuisineQuizPage(),
          settings: settings,
        );
      case quizDevWebRouter:
        return MaterialPageRoute(
          builder: (_) => const DeveloppementWebQuizPage(),
          settings: settings,
        );
      case quizAnglaisRouter:
        return MaterialPageRoute(
          builder: (_) => const AnglaisQuizPage(),
          settings: settings,
        );
      case historyRouter:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Introuvable'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Page Introuvable: ${settings.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(loginRouter);
                    },
                    child: const Text('Retour à la connexion'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
