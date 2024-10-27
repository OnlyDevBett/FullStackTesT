import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cars/app/core/repositories/auth_repository.dart';
import 'package:cars/app/core/repositories/splash_respository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SplashRepositry _splashRepositry = SplashRepositry();
  SplashBloc() : super(const SplashState()) {
    on<SplashInitialEvent>(_onSplashInitialEvent);
  }

  Future<void> _onSplashInitialEvent(
      SplashInitialEvent event, Emitter<SplashState> emit) async {
    // final connectivityResult = await Connectivity().checkConnectivity();
    // print(connectivityResult);


    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      emit(state.copyWith(status: SplashStatus.loading));
      String? userToken = await _splashRepositry.userAuthToken();
      if (userToken != null) {
        debugPrint('Authorized');
        AuthRepository().init();
        emit(state.copyWith(status: SplashStatus.authorized));
      } else {
        debugPrint('UnAuthorized');
        emit(state.copyWith(status: SplashStatus.unAuthorized));
      }
      // Mobile network available.
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      emit(state.copyWith(status: SplashStatus.loading));
      String? userToken = await _splashRepositry.userAuthToken();
      if (userToken != null) {
        debugPrint('Authorized');
        AuthRepository().init();
        emit(state.copyWith(status: SplashStatus.authorized));
      } else {
        debugPrint('UnAuthorized');
        emit(state.copyWith(status: SplashStatus.unAuthorized));
      }
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      debugPrint('No Internet Connection');
      emit(state.copyWith(
        status: SplashStatus.failure,
        toastMessage: 'No Internet Connection',
      ));
    }
    // final hasInternet = (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi);
    //
    //
    //
    // if (!hasInternet) {
    //   debugPrint('No Internet Connection');
    //   emit(state.copyWith(
    //     status: SplashStatus.failure,
    //     toastMessage: 'No Internet Connection',
    //   ));
    // }
  }
}
