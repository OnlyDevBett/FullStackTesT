/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:12
 * Project Name: IntelliJ IDEA
 * File Name: car_model


 */


class CarModel {
  final int id;
  final String make;
  final String model;
  final int year;
  final double price;

  CarModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.price,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'price': price,
    };
  }
}