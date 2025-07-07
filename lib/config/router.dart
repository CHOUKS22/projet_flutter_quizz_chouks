import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../pages/forms/login.dart';
import '../pages/forms/register.dart';
import '../home_page.dart';
import '../pages/quiz/quiz_page.dart';
import '../pages/history/history_page.dart';
import '../pages/admin/admin_add_question_page.dart';

class AppRouter {
  static const String adminAddQuestionRouter = '/admin/add-question';
  static const String rootRouter = '/';
  static const String loginRouter = '/login';
  static const String registerRouter = '/register';
  static const String homePageRouter = '/home';
  static const String quizRouter = '/quiz';
  static const String historyRouter = '/history';
  static const String adminAddCategoryRouter = '/admin/add-category';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case adminAddQuestionRouter:
        final user = settings.arguments;
        if (user == null || user is! UserModel) {
          return _errorRoute("Utilisateur non trouvé pour la page d'ajout de question");
        }
        return MaterialPageRoute(builder: (_) => AdminQuestionForm(user: user));
      case rootRouter:
      case loginRouter:
        return MaterialPageRoute(builder: (_) => const LoginForm());
      case adminAddCategoryRouter:
        // Redirige vers la page d'ajout de question admin, nécessite un utilisateur
        return _errorRoute("Navigation directe vers l'ajout de catégorie non supportée. Utilisez l'interface d'administration.");
      case registerRouter:
        return MaterialPageRoute(builder: (_) => const RegisterForm());
      case homePageRouter:
        final user = settings.arguments;
        if (user == null || user is! UserModel) {
          return _errorRoute("Utilisateur non trouvé pour la page d'accueil");
        }
        return MaterialPageRoute(builder: (_) => HomeScreen(user: user));
      case quizRouter:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null ||
            args['user'] == null ||
            args['user'] is! UserModel) {
          return _errorRoute(
            "Paramètres du quiz manquants ou utilisateur non trouvé",
          );
        }
        return MaterialPageRoute(
          builder: (_) => QuizScreen(
            title: args['title'] ?? 'Quiz',
            category: args['category'] ?? '',
            level: args['difficulty'] ?? 'Facile',
            questions: args['questions'] ?? [],
            user: args['user'],
          ),
        );
      case historyRouter:
        final user = settings.arguments;
        if (user == null || user is! UserModel) {
          return _errorRoute("Utilisateur non trouvé pour l'historique");
        }
        return MaterialPageRoute(builder: (_) => HistoryPage(user: user));
      default:
        return _errorRoute('404 - Page introuvable');
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
