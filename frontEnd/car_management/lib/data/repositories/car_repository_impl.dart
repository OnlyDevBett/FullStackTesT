import 'dart:convert';

import 'package:car/data/models/car_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../constants/api_constants.dart';
import '../../domain/repositories/car_repository.dart';
import '../../error/failures.dart';
import '../../services/secure_storage_service.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:13
 * Project Name: IntelliJ IDEA
 * File Name: car_repository_impl


 */


class CarRepositoryImpl implements CarRepository {
  final http.Client client;
  final WebSocketChannel? wsChannel;

  CarRepositoryImpl(this.client, this.wsChannel);

  Future<String?> _getToken() async {
    return await SecureStorageService.getToken();
  }

  @override
  Future<Either<Failure, List<CarModel>>> getCars() async {
    try {
      final token = await _getToken();
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cars}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> carList = json.decode(response.body);
        final cars = carList.map((car) => CarModel.fromJson(car)).toList();
        return Right(cars);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure('Session expired. Please login again.'));
      } else {
        return Left(ServerFailure('Failed to fetch cars'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CarModel>> createCar(CarModel car) async {
    try {
      final token = await _getToken();
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cars}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(car.toJson()),
      );

      if (response.statusCode == 201) {
        final newCar = CarModel.fromJson(json.decode(response.body));
        return Right(newCar);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure('Session expired. Please login again.'));
      } else {
        return Left(ServerFailure('Failed to create car'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CarModel>> updateCar(CarModel car) async {
    try {
      final token = await _getToken();
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cars}/${car.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(car.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedCar = CarModel.fromJson(json.decode(response.body));
        return Right(updatedCar);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure('Session expired. Please login again.'));
      } else {
        return Left(ServerFailure('Failed to update car'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCar(int id) async {
    try {
      final token = await _getToken();
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cars}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Right(null);
      } else if (response.statusCode == 401) {
        return Left(AuthFailure('Session expired. Please login again.'));
      } else {
        return Left(ServerFailure('Failed to delete car'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<CarModel> getCarUpdates() {
    // TODO: implement getCarUpdates
    throw UnimplementedError();
  }
}