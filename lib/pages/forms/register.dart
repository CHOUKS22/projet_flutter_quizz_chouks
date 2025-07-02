import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../fonctions/database_helper.dart';
import '../../config/router.dart';

// Widget pour le formulaire d'inscription
class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String username = "";
  String email = "";
  String password = "";
  String passwordConfirmation = "";
  bool isRememberMe = false;
  UserModel? _currentUser;

  void _showMessage(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          backgroundColor: isSuccess ? Colors.green[50] : Colors.red[50],
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.of(context).pushReplacementNamed(
                    AppRouter.homePageRouter,
                    arguments: _currentUser,
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool _validateForm() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty) {
      _showMessage("Erreur", "Veuillez remplir tous les champs", false);
      return false;
    }
    if (passwordController.text != passwordConfirmationController.text) {
      _showMessage("Erreur", "Les mots de passe ne correspondent pas", false);
      return false;
    }
    if (!emailController.text.contains('@')) {
      _showMessage("Erreur", "Veuillez entrer un email valide", false);
      return false;
    }
    return true;
  }

  Future<void> _onRegister() async {
    setState(() {
      username = usernameController.text;
      email = emailController.text;
      password = passwordController.text;
      passwordConfirmation = passwordConfirmationController.text;
    });
    if (!_validateForm()) {
      return;
    }
    UserModel newUser = UserModel(
      id: null,
      username: username,
      email: email,
      password: password,
    );
    try {
      bool emailExists = await _databaseHelper.emailExists(email);
      if (emailExists) {
        _showMessage("Erreur", "Cet email est déjà utilisé", false);
        return;
      }
      int userId = await _databaseHelper.insertUser(newUser);
      if (userId > 0) {
        UserModel? connectedUser = await _databaseHelper.loginUser(email, password);
        if (connectedUser != null) {
          _currentUser = connectedUser;
          _showMessage(
            "Succès",
            "Inscription réussie! Vous êtes maintenant connecté. ID: $userId",
            true,
          );
          _clearForm();
        } else {
          _showMessage("Erreur", "Inscription réussie mais erreur de connexion automatique", false);
        }
      } else {
        _showMessage("Erreur", "Erreur lors de l'inscription", false);
      }
    } catch (e) {
      _showMessage("Erreur", "Erreur: $e", false);
    }
  }

  void _clearForm() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    setState(() {
      isRememberMe = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Créer un compte',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordConfirmationController,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          if (_validateForm()) {
                            setState(() {
                              username = usernameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                              passwordConfirmation = passwordConfirmationController.text;
                            });
                            if (!_validateForm()) {
                              return;
                            }
                            UserModel newUser = UserModel(
                              id: null,
                              username: username,
                              email: email,
                              password: password,
                            );
                            try {
                              bool emailExists = await _databaseHelper.emailExists(email);
                              if (emailExists) {
                                _showMessage("Erreur", "Cet email est déjà utilisé", false);
                                return;
                              }
                              int userId = await _databaseHelper.insertUser(newUser);
                              if (userId > 0) {
                                UserModel? connectedUser = await _databaseHelper.loginUser(email, password);
                                if (connectedUser != null) {
                                  _currentUser = connectedUser;
                                  _showMessage(
                                    "Succès",
                                    "Inscription réussie! Vous êtes maintenant connecté. ID: $userId",
                                    true,
                                  );
                                  _clearForm();
                                } else {
                                  _showMessage("Erreur", "Inscription réussie mais erreur de connexion automatique", false);
                                }
                              } else {
                                _showMessage("Erreur", "Erreur lors de l'inscription", false);
                              }
                            } catch (e) {
                              _showMessage("Erreur", "Erreur: $e", false);
                            }
                          }
                        },
                        child: const Text('S\'inscrire', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Déjà un compte ? Se connecter'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Ajout de la méthode pour vérifier si un email existe déjà
// à placer dans DatabaseHelper si ce n'est pas déjà fait
extension EmailExists on DatabaseHelper {
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
