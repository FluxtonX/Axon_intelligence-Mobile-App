import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String freelancerId;
  final String title;
  final String category;
  final String description;
  final double price;
  final int deliveryDays;
  final String? imageUrl;
  final DateTime createdAt;

  const ServiceEntity({
    required this.id,
    required this.freelancerId,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.deliveryDays,
    this.imageUrl,
    required this.createdAt,
  });

  factory ServiceEntity.fromJson(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['id'] as String,
      freelancerId: json['freelancerId'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      deliveryDays: json['deliveryDays'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'freelancerId': freelancerId,
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'deliveryDays': deliveryDays,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        freelancerId,
        title,
        category,
        description,
        price,
        deliveryDays,
        imageUrl,
        createdAt,
      ];
}
