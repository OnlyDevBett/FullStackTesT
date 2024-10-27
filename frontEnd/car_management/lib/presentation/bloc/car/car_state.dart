/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:47
 * Project Name: IntelliJ IDEA
 * File Name: car_state


 */


import 'package:equatable/equatable.dart';

import '../../../data/models/car_model.dart';

/// Enum to define different types of car updates
enum CarUpdateType {
  created,
  updated,
  deleted,
}

/// Enum to define different sorting criteria
enum CarSortCriteria {
  price,
  year,
  make,
  model,
}

/// Base state class for Car BLoC
abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the BLoC is created
class CarInitial extends CarState {}

/// State when cars are being loaded
class CarLoading extends CarState {
  final bool isFirstLoad;

  const CarLoading({this.isFirstLoad = true});

  @override
  List<Object> get props => [isFirstLoad];
}

/// State when cars are successfully loaded
class CarLoaded extends CarState {
  final List<CarModel> cars;
  final List<CarModel> filteredCars;
  final CarModel? selectedCar;
  final bool hasMorePages;
  final int currentPage;
  final CarSortCriteria? currentSortCriteria;
  final bool isAscending;
  final Map<String, dynamic> activeFilters;
  final bool isFiltered;

  const CarLoaded({
    required this.cars,
    this.filteredCars = const [],
    this.selectedCar,
    this.hasMorePages = false,
    this.currentPage = 1,
    this.currentSortCriteria,
    this.isAscending = true,
    this.activeFilters = const {},
    this.isFiltered = false,
  });

  /// Create a copy of the state with updated fields
  CarLoaded copyWith({
    List<CarModel>? cars,
    List<CarModel>? filteredCars,
    CarModel? selectedCar,
    bool? hasMorePages,
    int? currentPage,
    CarSortCriteria? currentSortCriteria,
    bool? isAscending,
    Map<String, dynamic>? activeFilters,
    bool? isFiltered,
  }) {
    return CarLoaded(
      cars: cars ?? this.cars,
      filteredCars: filteredCars ?? this.filteredCars,
      selectedCar: selectedCar ?? this.selectedCar,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      currentPage: currentPage ?? this.currentPage,
      currentSortCriteria: currentSortCriteria ?? this.currentSortCriteria,
      isAscending: isAscending ?? this.isAscending,
      activeFilters: activeFilters ?? this.activeFilters,
      isFiltered: isFiltered ?? this.isFiltered,
    );
  }

  @override
  List<Object?> get props => [
    cars,
    filteredCars,
    selectedCar,
    hasMorePages,
    currentPage,
    currentSortCriteria,
    isAscending,
    activeFilters,
    isFiltered,
  ];
}

/// State when an error occurs
class CarError extends CarState {
  final String message;
  final bool isAuthError;
  final CarState? previousState;

  const CarError({
    required this.message,
    this.isAuthError = false,
    this.previousState,
  });

  @override
  List<Object?> get props => [message, isAuthError, previousState];
}

/// State when car operation is in progress
class CarOperationInProgress extends CarState {
  final String operation;
  final CarModel? car;

  const CarOperationInProgress({
    required this.operation,
    this.car,
  });

  @override
  List<Object?> get props => [operation, car];
}

/// State when car operation is successful
class CarOperationSuccess extends CarState {
  final String message;
  final CarModel? car;
  final CarUpdateType updateType;

  const CarOperationSuccess({
    required this.message,
    this.car,
    required this.updateType,
  });

  @override
  List<Object?> get props => [message, car, updateType];
}

/// State for offline mode
class CarOfflineState extends CarState {
  final List<CarModel> cachedCars;
  final DateTime lastSyncTime;

  const CarOfflineState({
    required this.cachedCars,
    required this.lastSyncTime,
  });

  @override
  List<Object> get props => [cachedCars, lastSyncTime];
}

/// Extension methods for CarState
extension CarStateExtensions on CarState {
  bool get isLoading => this is CarLoading;
  bool get isLoaded => this is CarLoaded;
  bool get hasError => this is CarError;
  bool get isOperating => this is CarOperationInProgress;
  bool get isOffline => this is CarOfflineState;

  CarLoaded? get asLoaded => this is CarLoaded ? this as CarLoaded : null;
  CarError? get asError => this is CarError ? this as CarError : null;
}