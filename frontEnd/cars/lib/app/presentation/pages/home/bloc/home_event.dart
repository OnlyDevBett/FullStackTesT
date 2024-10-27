part of 'home_bloc.dart';

sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class HomeLogoutEvent extends HomeEvent {}

final class HomeUpdateStatusPostEvent extends HomeEvent {
  final int index;
  final CarModel postModel;

  HomeUpdateStatusPostEvent({required this.index, required this.postModel});
}

final class HomeDeletePostEvent extends HomeEvent {
  final CarModel postModel;

  HomeDeletePostEvent({required this.postModel});
}
