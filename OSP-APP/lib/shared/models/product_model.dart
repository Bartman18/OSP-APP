import 'package:osp/shared/product_expiration_enum.dart';

class ProductModel {
  final int id;
  final String name;
  final DateTime expirationDate;
  final String categoryId;
  final String description;
  final int fridgeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? userCategoryId;
  final DateTime? deletedAt;
  final String thumbnail;
  final List<dynamic> media;

  ProductExpiration productExpiration = ProductExpiration.longer;

  ProductModel({
    required this.id,
    required this.name,
    required this.expirationDate,
    required this.categoryId,
    required this.description,
    required this.fridgeId,
    required this.createdAt,
    required this.updatedAt,
    required this.userCategoryId,
    required this.deletedAt,
    required this.thumbnail,
    required this.media,
  }) {
    productExpiration = _isProductExpired();
  }

  int getDaysLeft() => expirationDate.difference(DateTime.now()).inDays;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      expirationDate: DateTime.parse(json['expiration_date']),
      categoryId: '${json['category_id']}',
      description: json['description'],
      fridgeId: json['fridge_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userCategoryId: json['user_category_id'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      thumbnail: json['thumbnail'],
      media: json['media'],
    );
  }

  ProductExpiration _isProductExpired() {
    final today = DateTime.now();
    final expirationDateOnly =
        DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    final difference = expirationDateOnly.difference(todayOnly).inDays;

    if (difference < 0) {
      return ProductExpiration.expired;
    }

    if (difference == 0) {
      return ProductExpiration.tomorrow;
    }

    if (difference == 1) {
      return ProductExpiration.today;
    }

    if (difference <= 3) {
      return ProductExpiration.threeDays;
    }

    return ProductExpiration.longer;
  }
}

List<ProductModel> mockProducts = [
  ProductModel(
    id: 1,
    name: 'Mleko',
    expirationDate: DateTime.now().add(const Duration(days: 7)),
    categoryId: '1',
    description: 'Mleko 2%',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 1,
    deletedAt: null,
    thumbnail:
        'https://strefaalergii.pl/wp-content/uploads/2024/02/mleko-wielbladzie-3.jpeg',
    media: [],
  ),
  ProductModel(
    id: 1,
    name: 'Mleko',
    expirationDate: DateTime.now().add(const Duration(days: 7)),
    categoryId: '1',
    description: 'Mleko 2%',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 1,
    deletedAt: null,
    thumbnail:
        'https://strefaalergii.pl/wp-content/uploads/2024/02/mleko-wielbladzie-3.jpeg',
    media: [],
  ),
  ProductModel(
    id: 1,
    name: 'Mleko',
    expirationDate: DateTime.now().add(const Duration(days: 7)),
    categoryId: '1',
    description: 'Mleko 2%',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 1,
    deletedAt: null,
    thumbnail:
        'https://strefaalergii.pl/wp-content/uploads/2024/02/mleko-wielbladzie-3.jpeg',
    media: [],
  ),
  ProductModel(
    id: 2,
    name: 'Chleb',
    expirationDate: DateTime.now().add(const Duration(days: 1)),
    categoryId: '2',
    description: 'Chleb pszenny',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 2,
    deletedAt: null,
    thumbnail:
        'https://smakowitychleb.pl/wp-content/uploads/2012/04/Smakowity-chleb-1200-x-6603-1.jpg',
    media: [],
  ),
  ProductModel(
    id: 3,
    name: 'Jajka',
    expirationDate: DateTime.now().add(const Duration(days: 10)),
    categoryId: '3',
    description: 'Jajka kurze',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 3,
    deletedAt: null,
    thumbnail:
        'https://ocdn.eu/images/pulscms/ZTE7MDA_/0a687f8a626dc6b5fcda0a1326bd8e52.jpeg',
    media: [],
  ),
  ProductModel(
    id: 31,
    name: 'Szynka',
    expirationDate: DateTime.now().add(const Duration(days: 7)),
    categoryId: '4',
    description: 'Szynka wieprzowa',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 4,
    deletedAt: null,
    thumbnail: '',
    media: [],
  ),
  ProductModel(
    id: 32,
    name: 'Ser feta',
    expirationDate: DateTime.now().add(const Duration(days: 10)),
    categoryId: '5',
    description: 'Ser feta grecki',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 5,
    deletedAt: null,
    thumbnail: '',
    media: [],
  ),
  ProductModel(
    id: 33,
    name: 'Oliwa z oliwek',
    expirationDate: DateTime.now().add(const Duration(days: 30)),
    categoryId: '6',
    description: 'Oliwa z oliwek extra virgin',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 6,
    deletedAt: null,
    thumbnail: '',
    media: [],
  ),
  ProductModel(
    id: 34,
    name: 'Cukier',
    expirationDate: DateTime.now().add(const Duration(days: 365)),
    categoryId: '7',
    description: 'Cukier biały',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 7,
    deletedAt: null,
    thumbnail: '',
    media: [],
  ),
  ProductModel(
    id: 30,
    name: 'Serek',
    expirationDate: DateTime.now().add(const Duration(days: 5)),
    categoryId: '10',
    description: 'Serek wiejski',
    fridgeId: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    userCategoryId: 10,
    deletedAt: null,
    thumbnail: '',
    media: [],
  ),
];
