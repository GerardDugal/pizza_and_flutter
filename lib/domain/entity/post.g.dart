// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      positions: (json['positions'] as List<dynamic>)
          .map((e) => Position.fromJson(e as Map<String, dynamic>))
          .toList(),
      prices: (json['prices'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, (e as List<dynamic>).map((e) => (e as num).toInt()).toList()),
      ),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'positions': instance.positions,
      'prices': instance.prices,
      'categories': instance.categories,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      deleted: json['deleted'] as bool,
      field_order: (json['field_order'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'deleted': instance.deleted,
      'field_order': instance.field_order,
    };

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      id: json['id'] as String,
      address_id: (json['address_id'] as num).toInt(),
      menu_cat_id: (json['menu_cat_id'] as num).toInt(),
      menu_type_id: (json['menu_type_id'] as num).toInt(),
      title: json['title'] as String,
      descr: json['descr'] as String,
      kcal: json['kcal'] as String,
      divider: json['divider'] as bool,
      weight: json['weight'] as String,
      image_url: json['image_url'] as String?,
      deleted: json['deleted'] as bool,
      field_order: (json['field_order'] as num).toInt(),
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'address_id': instance.address_id,
      'menu_cat_id': instance.menu_cat_id,
      'menu_type_id': instance.menu_type_id,
      'title': instance.title,
      'descr': instance.descr,
      'kcal': instance.kcal,
      'divider': instance.divider,
      'weight': instance.weight,
      'image_url': instance.image_url,
      'deleted': instance.deleted,
      'field_order': instance.field_order,
    };
