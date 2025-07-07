// ✅ Fichier : database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/score_model.dart';
import 'password_hasher.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE scores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        score INTEGER NOT NULL,
        category TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        date_played TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL,
        difficulty TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');
  }

  // Nouvelle méthode pour insérer une catégorie
  Future<int> insertCategory(String name) async {
    final db = await database;
    return await db.insert('categories', {
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Récupérer toutes les catégories
  Future<List<String>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories', orderBy: 'name');
    return result.map((e) => e['name'] as String).toList();
  }

  // Autres méthodes existantes inchangées (insertUser, loginUser, insertScore, getScoresByUser, etc.)

  Future<void> insertQuestion({
    required String question,
    required List<String> options,
    required String answer,
    required String category,
    required String difficulty,
  }) async {
    final db = await database;
    await db.insert('questions', {
      'question': question,
      'options': options.join(';'),
      'answer': answer,
      'category': category,
      'difficulty': difficulty,
    });
  }

  Future<List<Map<String, dynamic>>> getQuestionsByCategoryAndDifficulty(
    String category,
    String difficulty,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'category = ? AND difficulty = ?',
      whereArgs: [category, difficulty],
    );
    return maps
        .map((q) => {...q, 'options': (q['options'] as String).split(';')})
        .toList();
  }

  // ✅ Remarque : tu peux supprimer insertCategoryIfNotExists() si elle n'est plus utilisée.

  //Register
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    try {
      // Hash du mot de passe avant stockage
      String hashedPassword = PasswordHasher.hashPassword(user.password);
      UserModel userWithHashedPassword = UserModel(
        id: user.id,
        username: user.username,
        email: user.email,
        password: hashedPassword,
      );
      return await db.insert('users', userWithHashedPassword.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      UserModel user = UserModel.fromMap(maps.first);
      // Vérification du mot de passe hashé
      bool isPasswordCorrect = PasswordHasher.verifyPassword(
        password,
        user.password,
      );
      if (isPasswordCorrect) {
        return user;
      }
    }
    return null;
  }

  // Vérifie si un email existe déjà (pour l'inscription)
  Future<bool> emailExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty;
  }

  // CRUD Score (exemple)
  Future<int> insertScore(ScoreModel score) async {
    final db = await database;
    return await db.insert('scores', score.toMap());
  }

  Future<List<ScoreModel>> getScoresByUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date_played DESC',
    );
    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  // Récupère tous les scores (pour l'historique)
  Future<List<ScoreModel>> getAllScores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      orderBy: 'date_played DESC',
    );
    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  // Ajout d'une méthode pour insérer un score à la fin du quiz
  // Appelle cette méthode dans QuizPage quand le quiz est terminé
  Future<void> saveQuizScore({
    required int userId,
    required int score,
    required String category,
    required String difficulty,
    required String datePlayed,
  }) async {
    final db = await database;
    await db.insert('scores', {
      'user_id': userId,
      'score': score,
      'category': category,
      'difficulty': difficulty,
      'date_played': datePlayed,
    });
  }

  // Récupère toutes les questions d'une catégorie donnée
  Future<List<Map<String, dynamic>>> getQuestionsByCategory(
    String category,
  ) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps
        .map(
          (q) => {
            ...q,
            'options': (q['options'] is String)
                ? (q['options'] as String).split(';')
                : q['options'],
          },
        )
        .toList();
  }

  // Ajoute une catégorie si elle n'existe pas déjà dans la table categories
  Future<void> insertCategoryIfNotExists(String name) async {
    final db = await database;
    await db.rawInsert('INSERT OR IGNORE INTO categories(name) VALUES (?)', [name]);
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
