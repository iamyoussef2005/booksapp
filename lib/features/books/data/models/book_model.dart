import 'package:json_annotation/json_annotation.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.stock,
    required this.isFeatured,
  });

  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final String description;
  final String category;
  final String imageUrl;
  final int stock;
  final bool isFeatured;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
