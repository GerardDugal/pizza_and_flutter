import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart'; // Сгенерированный файл


@JsonSerializable()
class Post {
  final List<Position> positions; // Список позиций
  final Map<String, List<int>> prices; // Карта с ценами
  final List<Category> categories; // Список категорий
  Post({required this.positions, required this.prices, required this.categories});

  // Фабрика для создания экземпляра из JSON
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  // Метод для конвертации экземпляра в JSON
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  final String title;
  final bool deleted;
  final int field_order;

  Category({
    required this.id,
    required this.title,
    required this.deleted,
    required this.field_order,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Position {
  final String id;
  final int address_id;
  final int menu_cat_id;
  final int menu_type_id;
  final String title;
  final String descr;
  final String kcal;
  final bool divider;
  final String weight;
  final String? image_url;
  final bool deleted;
  final int field_order;

  Position({
    required this.id,
    required this.address_id,
    required this.menu_cat_id,
    required this.menu_type_id,
    required this.title,
    required this.descr,
    required this.kcal,
    required this.divider,
    required this.weight,
    required this.image_url,
    required this.deleted,
    required this.field_order,
  });

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
}
