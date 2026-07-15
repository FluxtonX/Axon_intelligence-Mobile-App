import 'package:equatable/equatable.dart';

class GigEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String description;
  final double price;
  final int deliveryDays;
  final String imageUrl;

  const GigEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.deliveryDays,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        description,
        price,
        deliveryDays,
        imageUrl,
      ];
}
