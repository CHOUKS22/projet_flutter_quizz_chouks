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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  UserModel? _currentUser;

  void _showMessage(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/app_icon.png',
                height: 100,
              ),
              const SizedBox(height: 20),

              // Form Card (fond blanc)
              Card(
                color: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Bienvenue !',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000), // Rouge
                            foregroundColor: Colors.white, // Texte blanc
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
            ],
          ),
        ),
      ),
    );
  }
}
