import 'package:equatable/equatable.dart';

import '../../../data/models/car_model.dart';
import 'car_state.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:34
 * Project Name: IntelliJ IDEA
 * File Name: car_event


 */


abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all cars from the repository
class LoadCars extends CarEvent {}

/// Event to create a new car
class CreateCar extends CarEvent {
  final CarModel car;

  const CreateCar(this.car);

  @override
  List<Object> get props => [car];
}

/// Event to update an existing car
class UpdateCar extends CarEvent {
  final CarModel car;

  const UpdateCar(this.car);

  @override
  List<Object> get props => [car];
}

/// Event to delete a car by its ID
class DeleteCar extends CarEvent {
  final int id;

  const DeleteCar(this.id);

  @override
  List<Object> get props => [id];
}

/// Event triggered when a car is updated through WebSocket
class CarUpdated extends CarEvent {
  final CarModel car;
  final CarUpdateType updateType;

  const CarUpdated(this.car, this.updateType);

  @override
  List<Object> get props => [car, updateType];
}

/// Event to filter cars based on search criteria
class FilterCars extends CarEvent {
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final int? minYear;
  final int? maxYear;
  final String? make;
  final String? model;

  const FilterCars({
    this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.minYear,
    this.maxYear,
    this.make,
    this.model,
  });

  @override
  List<Object?> get props => [
    searchQuery,
    minPrice,
    maxPrice,
    minYear,
    maxYear,
    make,
    model,
  ];
}

/// Event to sort cars by different criteria
class SortCars extends CarEvent {
  final CarSortCriteria criteria;
  final bool ascending;

  const SortCars({
    required this.criteria,
    this.ascending = true,
  });

  @override
  List<Object> get props => [criteria, ascending];
}

/// Event to refresh the car list
class RefreshCars extends CarEvent {}

/// Event to handle pagination
class LoadMoreCars extends CarEvent {
  final int page;
  final int pageSize;

  const LoadMoreCars({
    required this.page,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [page, pageSize];
}

/// Event to clear all filters and sorting
class ClearFiltersAndSort extends CarEvent {}

/// Event to handle car selection
class SelectCar extends CarEvent {
  final CarModel car;

  const SelectCar(this.car);

  @override
  List<Object> get props => [car];
}

/// Event to clear car selection
class ClearSelection extends CarEvent {}