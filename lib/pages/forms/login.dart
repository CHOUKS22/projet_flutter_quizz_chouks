import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../fonctions/database_helper.dart';
import '../../config/router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
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
                if (isSuccess && _currentUser != null) {
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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage("Erreur", "Veuillez remplir tous les champs", false);
      return false;
    }
    if (!_emailController.text.contains('@')) {
      _showMessage("Erreur", "Veuillez entrer un email valide", false);
      return false;
    }
    return true;
  }

  Future<void> onSubmit() async {
    setState(() {
      email = _emailController.text;
      password = _passwordController.text;
    });
    if (!_validateForm()) {
      return;
    }
    try {
      UserModel? user = await _databaseHelper.loginUser(email, password);
      if (user != null) {
        _currentUser = user;
        _showMessage(
          "Connexion réussie",
          "Bienvenue ${user.username}!",
          true,
        );
      } else {
        _showMessage(
          "Erreur de connexion",
          "Email ou mot de passe incorrect",
          false,
        );
      }
    } catch (e) {
      _showMessage("Erreur", "Erreur lors de la connexion: $e", false);
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      email = '';
      password = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
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
                        'Bienvenue !',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.lock),
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
                            final user = await _databaseHelper.loginUser(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (user != null) {
                              setState(() => _currentUser = user);
                              _showMessage('Succès', 'Connexion réussie', true);
                            } else {
                              _showMessage('Erreur', 'Email ou mot de passe incorrect', false);
                            }
                          }
                        },
                        child: const Text('Se connecter', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/register');
                        },
                        child: const Text("Pas encore de compte ? S'inscrire"),
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
