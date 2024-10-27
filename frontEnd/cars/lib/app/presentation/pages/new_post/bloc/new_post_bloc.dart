import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cars/app/core/models/car_model.dart';
import 'package:flutter/material.dart';
import 'package:cars/app/core/config/api.service.dart';
import 'package:cars/app/core/models/post_model.dart';
import 'package:cars/app/core/repositories/auth_repository.dart';
import 'package:cars/app/core/repositories/post_repository.dart';
import 'package:cars/app/core/validations/new_post_form.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  NewPostBloc() : super(const NewPostState()) {
    on<NewPostInitialEvent>(_onNewPostInitialEvent);


    on<PostTitleChanged>(_onTitleChanged);

    on<PostTitleUnfocused>(_onTitleUnfocused);

    on<PostDescriptionChanged>(_onDescriptionChanged);

    on<PostDescriptionUnfocused>(_onDescriptionUnfocused);

    on<PostFormSubmitted>(_onPostFormSubmitted);
  }

  Future<void> _onNewPostInitialEvent(
      NewPostInitialEvent event, Emitter<NewPostState> emit) async {
    debugPrint('is New? ${event.action}, and the id ${event.postModel.id}');
    if (event.action == 'update') {
      debugPrint('update');
      emit(
        state.copyWith(
          name: PostTitleField.pure(event.postModel.name!),
          model: PostDescriptionField.pure(event.postModel.model!),
          price: CarPrice.pure(event.postModel.price!.toString()),
          isValid: Formz.validate([
            state.name,
            state.model,
            state.price,
          ]),
        ),
      );
    }
  }



  Future<void> _onTitleChanged(
      PostTitleChanged event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(event.title);
    emit(
      state.copyWith(
        name: title.isValid ? title : PostTitleField.pure(event.title),
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.price, state.model]),
      ),
    );
  }

  Future<void> _onTitleUnfocused(
      PostTitleUnfocused event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.name.value);
    emit(
      state.copyWith(
        name: title,
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.model, state.price]),
      ),
    );
  }

  Future<void> _onDescriptionChanged(
      PostDescriptionChanged event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(event.description);
    emit(
      state.copyWith(
        model: description.isValid
            ? description
            : PostDescriptionField.pure(event.description),
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.model, state.price]),
      ),
    );
  }

  Future<void> _onDescriptionUnfocused(
      PostDescriptionUnfocused event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(state.model.value);
    emit(
      state.copyWith(
        model: description,
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.model, state.price]),
      ),
    );
  }

  Future<void> _onPostFormSubmitted(
      PostFormSubmitted event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.name.value);
    final description = PostDescriptionField.dirty(state.model.value);
    final price = CarPrice.dirty(state.price.value);
    emit(
      state.copyWith(
        name: title,
        model: description,
        price: price,
        status: AddPostStatus.initial,
        isValid: Formz.validate([
          title,
          description,
          price,
        ]),
      ),
    );
    if (state.isValid) {
      debugPrint('ok Submit');
      if (event.action == 'create') {
        debugPrint('create');
        emit(state.copyWith(status: AddPostStatus.submitting));
        try {
          var param = {
            "price": state.price.value.toString(),
            "name": state.name.value.toString(),
            "model": state.model.value.toString(),
            "user_id": AuthRepository.userId,

          };
          HttpResponse response = await PostRepository().createPost(param);
          debugPrint(response.statusCode.toString());
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(
              status: AddPostStatus.success,
              toastMessage: 'Post Saved',
            ));
          } else if (response.statusCode == 500) {
            Map<String, dynamic>? myMap =
                jsonDecode(response.body) as Map<String, dynamic>;
            if (myMap.containsKey('success') &&
                myMap.containsKey('message') &&
                myMap['success'] == false) {
              emit(state.copyWith(
                status: AddPostStatus.failure,
                toastMessage: myMap['message'].toString(),
              ));
            } else {
              debugPrint('API ERROR in 500-> ${response.body.toString()}');
              emit(
                state.copyWith(
                    status: AddPostStatus.failure,
                    toastMessage: 'Something went wrong'),
              );
            }
          } else {
            debugPrint('API ERROR-> ${response.body.toString()}');
            emit(
              state.copyWith(
                  status: AddPostStatus.failure,
                  toastMessage: 'Something went wrong'),
            );
          }
        } catch (e) {
          debugPrint('Catch Error ${e.toString()}');
          emit(state.copyWith(status: AddPostStatus.failure));
        }
      } else {
        debugPrint('update');
        emit(state.copyWith(status: AddPostStatus.submitting));
        try {
          var param = {
            "price": state.price.value.toString(),
            "name": state.name.value.toString(),
            "model": state.model.value.toString(),
            "id": event.postModel.id
          };
          HttpResponse response = await PostRepository().updatePost(param);
          debugPrint(response.statusCode.toString());
          if (response.errorType == NetErrorType.none) {
            emit(state.copyWith(
              status: AddPostStatus.success,
              toastMessage: 'Post Updated',
            ));
          } else if (response.statusCode == 500) {
            Map<String, dynamic>? myMap =
                jsonDecode(response.body) as Map<String, dynamic>;
            if (myMap.containsKey('success') &&
                myMap.containsKey('message') &&
                myMap['success'] == false) {
              emit(state.copyWith(
                status: AddPostStatus.failure,
                toastMessage: myMap['message'].toString(),
              ));
            } else {
              debugPrint('API ERROR in 500-> ${response.body.toString()}');
              emit(
                state.copyWith(
                    status: AddPostStatus.failure,
                    toastMessage: 'Something went wrong'),
              );
            }
          } else {
            debugPrint('API ERROR-> ${response.body.toString()}');
            emit(
              state.copyWith(
                  status: AddPostStatus.failure,
                  toastMessage: 'Something went wrong'),
            );
          }
        } catch (e) {
          debugPrint('Catch Error ${e.toString()}');
          emit(state.copyWith(status: AddPostStatus.failure));
        }
      }
    }
  }
}
