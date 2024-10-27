import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../error/failures.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:13
 * Project Name: IntelliJ IDEA
 * File Name: auth_repository_impl


 */

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl(this.client);

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        return Right(token);
      } else {
        return Left(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        return Right(token);
      } else {
        return Left(AuthFailure('Invalid credentials'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}