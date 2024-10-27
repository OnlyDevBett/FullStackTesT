import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cars/app/core/config/api.service.dart';
import 'package:cars/app/core/models/post_model.dart';
import 'package:cars/app/core/repositories/auth_repository.dart';
import 'package:cars/app/core/repositories/post_repository.dart';
import 'package:cars/app/services/shared_pref.dart';

import '../../../../core/models/car_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository = AuthRepository();
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  List<CarModel> list = <CarModel>[];

  HomeBloc() : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeLogoutEvent>(_onHomeLogoutEvent);
    on<HomeUpdateStatusPostEvent>(_onHomeUpdateStatusPostEvent);
    on<HomeDeletePostEvent>(_onHomeDeletePostEvent);
  }

  Future<void> _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    debugPrint('get My Post');
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      HttpResponse response = await PostRepository().getMyPost();
      debugPrint(response.statusCode.toString());
      if (response.errorType == NetErrorType.none) {
        debugPrint(response.body.toString());
        Map<String, dynamic>? myMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        dynamic body = myMap["data"];
        list.clear();
        body.forEach((data) {
          CarModel datas = CarModel.fromJson(data);
          list.add(datas);
        });
        debugPrint(
            '************************************************ ${list.length.toString()}');
        emit(
          state.copyWith(
            status: HomeStatus.success,
            list: [...list],
          ),
        );
      } else if (response.statusCode == 401) {
        debugPrint('unauthorized');
        await _sharedPreferencesManager.clearKey('_authToken');
        await _sharedPreferencesManager.clearKey('isLoggedIn');
        emit(
          state.copyWith(
            status: HomeStatus.unAuthorized,
            toastMesssage: 'Unauthorized',
          ),
        );
      }
    } catch (e) {
      debugPrint('Something went wrong ${e.toString()}');
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeLogoutEvent(
      HomeLogoutEvent event, Emitter<HomeState> emit) async {
    debugPrint('logout');

    try {
      emit(state.copyWith(status: HomeStatus.loading));
      HttpResponse response = await _authRepository.logout();
      debugPrint(response.statusCode.toString());
      if (response.errorType == NetErrorType.none) {
        debugPrint('logout successfull');
        Map<String, dynamic>? myMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (myMap.containsKey('status') &&
            myMap.containsKey('success') &&
            myMap.containsKey('success') == true) {
          await _sharedPreferencesManager.clearKey('_authToken');
          await _sharedPreferencesManager.clearKey('isLoggedIn');
          emit(
            state.copyWith(
              status: HomeStatus.logout,
              toastMesssage: myMap.containsKey('message')
                  ? myMap['message']
                  : 'Logged Out',
            ),
          );
        } else {
          debugPrint('success maps issue');
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              toastMesssage: 'Something went wrong',
            ),
          );
        }
      } else if (response.statusCode == 500) {
        Map<String, dynamic>? myMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (myMap.containsKey('success') &&
            myMap.containsKey('message') &&
            myMap['success'] == false) {
          emit(state.copyWith(
              status: HomeStatus.failure,
              toastMesssage: myMap['message'].toString()));
        } else {
          debugPrint('API ERROR in 500-> ${response.body.toString()}');
          emit(state.copyWith(
              status: HomeStatus.failure,
              toastMesssage: 'Something went wrong'));
        }
      } else if (response.statusCode == 401) {
        debugPrint('unauthorized');
        Map<String, dynamic>? myMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        emit(state.copyWith(
            status: HomeStatus.unAuthorized,
            toastMesssage: myMap.containsKey('error')
                ? myMap['error'].toString()
                : 'Something went wrong'));
      } else {
        debugPrint('API ERROR-> ${response.body.toString()}');
        emit(state.copyWith(
            status: HomeStatus.failure, toastMesssage: 'Something went wrong'));
      }
    } catch (e) {
      debugPrint('catch login error ${e.toString()}');
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeUpdateStatusPostEvent(
      HomeUpdateStatusPostEvent event, Emitter<HomeState> emit) async {
    debugPrint('update status');
    try {
      event.postModel.availabilityStatus = event.postModel.availabilityStatus == true ? false : true;
      HttpResponse response = await PostRepository().updatePost({
        "id": int.parse(event.postModel.id.toString()),
        "status": event.postModel.availabilityStatus
      });
      if (response.errorType == NetErrorType.none) {
        list[event.index] = event.postModel;
        emit(
          state.copyWith(
            status: HomeStatus.success,
            list: [...list],
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            toastMesssage: 'Something went wrong',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeDeletePostEvent(
      HomeDeletePostEvent event, Emitter<HomeState> emit) async {
    debugPrint('call delete api with this id ${event.postModel.id}');
    try {
      debugPrint(event.postModel.name.toString());
      debugPrint(event.postModel.id.toString());
      list.removeWhere((element) => element.id == event.postModel.id);

      HttpResponse response = await PostRepository()
          .deletePost(int.parse(event.postModel.id.toString()));
      if (response.errorType == NetErrorType.none) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            list: [...list],
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            toastMesssage: 'Something went wrong',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMesssage: e.toString(),
        ),
      );
    }
  }
}
