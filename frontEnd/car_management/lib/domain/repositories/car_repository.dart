import 'package:dartz/dartz.dart';

import '../../data/models/car_model.dart';
import '../../error/failures.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:15
 * Project Name: IntelliJ IDEA
 * File Name: car_repository


 */

abstract class CarRepository {
  Future<Either<Failure, List<CarModel>>> getCars();
  Stream<CarModel> getCarUpdates();
}
