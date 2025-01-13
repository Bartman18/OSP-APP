import 'package:osp/shared/models/product_model.dart';

class AddProductModel {
  String name;
  DateTime expirationDate;
  int categoryId;
  String description;

  AddProductModel({
    required this.name,
    required this.expirationDate,
    required this.categoryId,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "expiration_date": expirationDate.toIso8601String(),
      "category_id": categoryId,
      "description": description
    };
  }
}

class UpdateProductModel extends AddProductModel {
  UpdateProductModel({
    required super.name,
    required super.expirationDate,
    required super.categoryId,
    required super.description,
  });
}

class ProductsPage {
  List<ProductModel> productModels;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int to;
  int total;

  ProductsPage({
    required this.productModels,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ProductsPage.fromJson(Map<String, dynamic> json) {
    final List<ProductModel> productModels = [];

    for (final product in json["data"]) {
      productModels.add(ProductModel.fromJson(product));
    }

    return ProductsPage(
      productModels: productModels,
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }
}

class ProductsCount {
  final int allProductsCount;
  final int shortDateProductsCount;

  ProductsCount({
    required this.allProductsCount,
    required this.shortDateProductsCount,
  });

  factory ProductsCount.fromJson(Map<String, dynamic> json) {
    return ProductsCount(
      allProductsCount: json["all_products_count"] ?? -1,
      shortDateProductsCount: json["short_date_products_count"] ?? -1,
    );
  }
}
