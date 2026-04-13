// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      stock: (json['stock'] as num).toInt(),
      isFeatured: json['isFeatured'] as bool,
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'price': instance.price,
      'rating': instance.rating,
      'description': instance.description,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'stock': instance.stock,
      'isFeatured': instance.isFeatured,
    };
