class UserScoreModel {
  int id;
  int userId;
  int score;
  DateTime createdAt;
  DateTime? updatedAt;

  UserScoreModel({
    required this.id,
    required this.userId,
    required this.score,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserScoreModel.fromJson(Map<String, dynamic> json) {
    return UserScoreModel(
      id: json['id'],
      userId: json['user_id'],
      score: json['score'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
