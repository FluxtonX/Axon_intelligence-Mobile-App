import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class LoadServices extends ServicesEvent {
  final String? query;
  final bool refresh;

  const LoadServices({this.query, this.refresh = false});

  @override
  List<Object?> get props => [query, refresh];
}

class LoadMyServices extends ServicesEvent {}

class CreateService extends ServicesEvent {
  final String title;
  final String category;
  final String description;
  final double price;
  final int deliveryDays;
  final String? imageUrl;

  const CreateService({
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.deliveryDays,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        title,
        category,
        description,
        price,
        deliveryDays,
        imageUrl,
      ];
}
