import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/api_constants.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/car_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/car_repository.dart';
import '../interceptors/auth_interceptor.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_event.dart';
import '../presentation/bloc/car/car_bloc.dart';
import '../presentation/bloc/car/car_event.dart';
import '../services/secure_storage_service.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:40
 * Project Name: IntelliJ IDEA
 * File Name: dependency_injection


 */

class DependencyInjection {
  static final GetIt locator = GetIt.instance;

  static Future<void> init() async {
    // Core
    locator.registerLazySingleton(() => SecureStorageService());

    // Http client
    final dio = Dio()..interceptors.add(AuthInterceptor() as Interceptor);
    locator.registerLazySingleton(() => dio);

    // WebSocket
    locator.registerLazySingleton(
          () => WebSocketChannel.connect(
        Uri.parse(ApiConstants.wsUrl),
      ),
    );

    // Repositories
    locator.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(locator()),
    );
    locator.registerLazySingleton<CarRepository>(
          () => CarRepositoryImpl(locator(), locator()),
    );

    // BLoCs
    locator.registerFactory(
          () => AuthBloc(locator())..add(CheckAuthStatus()),
    );
    locator.registerFactory(
          () => CarBloc(locator())..add(LoadCars()),
    );
  }
}