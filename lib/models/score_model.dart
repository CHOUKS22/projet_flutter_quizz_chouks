// Modèle score/partie

class ScoreModel {
  final int? id;
  final int userId;
  final int score;
  final String category;
  final String difficulty;
  final String datePlayed;

  ScoreModel({
    this.id,
    required this.userId,
    required this.score,
    required this.category,
    required this.difficulty,
    required this.datePlayed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'score': score,
      'category': category,
      'difficulty': difficulty,
      'date_played': datePlayed,
    };
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'],
      userId: map['user_id'],
      score: map['score'],
      category: map['category'],
      difficulty: map['difficulty'],
      datePlayed: map['date_played'],
    );
  }
}
