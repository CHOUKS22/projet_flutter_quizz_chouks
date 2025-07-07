import 'package:flutter/material.dart';
import '../../fonctions/database_helper.dart';
import '../../models/user_model.dart';

class AdminQuestionForm extends StatefulWidget {
  final UserModel user;
  const AdminQuestionForm({Key? key, required this.user}) : super(key: key);
  @override
  State<AdminQuestionForm> createState() => _AdminQuestionFormState();
}

class _AdminQuestionFormState extends State<AdminQuestionForm> {
  final formKey = GlobalKey<FormState>();
  final questionCtrl = TextEditingController();
  final answerCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final List<TextEditingController> optionCtrls = List.generate(4, (_) => TextEditingController());
  String selectedDifficulty = 'Facile';
  final List<String> difficulties = ['Facile', 'Moyen', 'Difficile'];
  List<String> categories = [];
  bool loadingCategories = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => loadingCategories = true);
    final cats = await DatabaseHelper().getAllCategories();
    setState(() {
      categories = cats;
      loadingCategories = false;
    });
  }

  @override
  void dispose() {
    questionCtrl.dispose();
    answerCtrl.dispose();
    categoryCtrl.dispose();
    for (var c in optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }


  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final question = questionCtrl.text.trim();
    final options = optionCtrls.map((c) => c.text.trim()).where((o) => o.isNotEmpty).toList();
    final answer = answerCtrl.text.trim();
    final category = categoryCtrl.text.trim();
    final difficulty = selectedDifficulty;
    if (!options.contains(answer)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La réponse doit être parmi les options.')));
      return;
    }
    if (category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez saisir une catégorie.')));
      return;
    }
    await DatabaseHelper().insertCategoryIfNotExists(category);
    await DatabaseHelper().insertQuestion(
      question: question,
      options: options,
      answer: answer,
      category: category,
      difficulty: difficulty,
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Question ajoutée !')));
    formKey.currentState!.reset();
    questionCtrl.clear();
    answerCtrl.clear();
    categoryCtrl.clear();
    for (var c in optionCtrls) {
      c.clear();
    }
    setState(() {});
  }

  // String? _selectedCategory; // Supprimé car non utilisé

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une question (Admin)'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home, color: Colors.deepOrange),
                label: const Text('Accueil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrange,
                  side: const BorderSide(color: Colors.deepOrange),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    '/home',
                    arguments: widget.user,
                  );
                },
              ),
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: questionCtrl,
                      decoration: const InputDecoration(labelText: 'Question'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(optionCtrls.length, (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: optionCtrls[i],
                        decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Champ requis' : null,
                      ),
                    )),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: answerCtrl,
                      decoration: const InputDecoration(labelText: 'Bonne réponse (doit être une des options)'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Champ requis' : null,
                    ),
                    const SizedBox(height: 16),
                    loadingCategories
                        ? const Center(child: CircularProgressIndicator())
                        : Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: categories.isNotEmpty ? categories.first : null,
                                  items: categories
                                      .map((cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(cat),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        categoryCtrl.text = value;
                                      });
                                    }
                                  },
                                  decoration: const InputDecoration(labelText: 'Catégorie'),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Champ requis' : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.deepOrange),
                                tooltip: 'Ajouter une catégorie',
                                onPressed: () async {
                                  final newCat = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      final ctrl = TextEditingController();
                                      return AlertDialog(
                                        title: const Text('Nouvelle catégorie'),
                                        content: TextField(
                                          controller: ctrl,
                                          decoration: const InputDecoration(labelText: 'Nom de la catégorie'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
                                            child: const Text('Ajouter'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (newCat != null && newCat.isNotEmpty) {
                                    await DatabaseHelper().insertCategoryIfNotExists(newCat);
                                    await loadCategories();
                                    setState(() {
                                      categoryCtrl.text = newCat;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      items: difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (v) => setState(() => selectedDifficulty = v!),
                      decoration: const InputDecoration(labelText: 'Difficulté'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      child: const Text('Ajouter la question'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
