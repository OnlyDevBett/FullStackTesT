import 'package:dartz/dartz.dart';

import '../../error/failures.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:15
 * Project Name: IntelliJ IDEA
 * File Name: auth_repository


 */

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, String>> register(String email, String password);
}