import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../fonctions/database_helper.dart';
import '../../config/router.dart';

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
      ),
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

  void _clearForm() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
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

              // Form Card
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
                          'Créer un compte',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Nom d\'utilisateur',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordConfirmationController,
                          decoration: InputDecoration(
                            labelText: 'Confirmer le mot de passe',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF0000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () async {
                            if (!_validateForm()) return;
                            setState(() {
                              username = usernameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                            });

                            final newUser = UserModel(
                              id: null,
                              username: username,
                              email: email,
                              password: password,
                            );

                            try {
                              final exists = await _databaseHelper.emailExists(email);
                              if (exists) {
                                _showMessage("Erreur", "Cet email est déjà utilisé", false);
                                return;
                              }

                              final userId = await _databaseHelper.insertUser(newUser);
                              if (userId > 0) {
                                final user = await _databaseHelper.loginUser(email, password);
                                if (user != null) {
                                  _currentUser = user;
                                  _showMessage("Succès", "Inscription réussie !", true);
                                  _clearForm();
                                } else {
                                  _showMessage("Erreur", "Connexion automatique échouée", false);
                                }
                              } else {
                                _showMessage("Erreur", "Erreur lors de l'inscription", false);
                              }
                            } catch (e) {
                              _showMessage("Erreur", "Exception : $e", false);
                            }
                          },
                          child: const Text("S'inscrire", style: TextStyle(fontSize: 16)),
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
            ],
          ),
        ),
      ),
    );
  }
}
