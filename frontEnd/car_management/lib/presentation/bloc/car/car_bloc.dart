import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/car_repository.dart';
import 'car_event.dart';
import 'car_state.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:17
 * Project Name: IntelliJ IDEA
 * File Name: car_bloc


 */


class CarBloc extends Bloc<CarEvent, CarState> {
  final CarRepository repository;
  
  StreamSubscription? _carUpdateSubscription;
  
  CarBloc(this.repository) : super(CarInitial()) {
    on<LoadCars>(_onLoadCars);
    on<CreateCar>(_onCreateCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar);
    on<FilterCars>(_onFilterCars);
    on<SortCars>(_onSortCars);
    on<LoadMoreCars>(_onLoadMoreCars);
    on<SelectCar>(_onSelectCar);
    on<ClearSelection>(_onClearSelection);
    // ... implement other event handlers
  }

  Future<void> _onLoadCars(LoadCars event, Emitter<CarState> emit) async {
    emit(CarLoading());
    try {
      final result = await repository.getCars();
      result.fold(
            (failure) => emit(CarError(message: failure.message)),
            (cars) => emit(CarLoaded(cars: cars)),
      );
      // Listen to real-time updates
      // _carUpdateSubscription = repository.getCarUpdates().listen((car) {
      //   add(CarUpdated(car));
      // });
    } catch (e) {
      emit(CarError(message: e.toString()));
    }
  }

// Implement other event handlers...

  FutureOr<void> _onCreateCar(CreateCar event, Emitter<CarState> emit) {
  }

  @override
  Future<void> close() {
    _carUpdateSubscription?.cancel();
    return super.close();
  }
  

  FutureOr<void> _onUpdateCar(UpdateCar event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onDeleteCar(DeleteCar event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onFilterCars(FilterCars event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onSortCars(SortCars event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onLoadMoreCars(LoadMoreCars event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onSelectCar(SelectCar event, Emitter<CarState> emit) {
  }

  FutureOr<void> _onClearSelection(ClearSelection event, Emitter<CarState> emit) {
  }
}

