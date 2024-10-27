import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../services/secure_storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:17
 * Project Name: IntelliJ IDEA
 * File Name: auth_bloc


 */


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await repository.login(event.email, event.password);

      await result.fold(
            (failure) async {
          emit(AuthError(failure.message));
          emit(AuthUnauthenticated());
        },
            (token) async {
          await SecureStorageService.saveToken(token);
          emit(AuthAuthenticated(token));
        },
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await SecureStorageService.deleteToken();
      emit(AuthUnauthenticated());
    });

    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());
      final token = await SecureStorageService.getToken();
      if (token != null) {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}