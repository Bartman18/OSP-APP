class UserFridgeModel {
  int id;
  String? name;
  int userId;
  DateTime createdAt;
  DateTime? updatedAt;

  UserFridgeModel({
    required this.id,
    this.name,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserFridgeModel.fromJson(Map<String, dynamic> json) {
    return UserFridgeModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );
  }
}