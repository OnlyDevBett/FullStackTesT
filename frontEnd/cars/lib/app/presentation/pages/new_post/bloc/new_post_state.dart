part of 'new_post_bloc.dart';

enum AddPostStatus {
  initial,
  loading,
  success,
  failure,
  uploadingImage,
  submitting,
  uploadedImage
}

extension AddPostStatusX on AddPostStatus {
  bool get isInitial => this == AddPostStatus.initial;
  bool get isLoading => this == AddPostStatus.loading;
  bool get isSuccess => this == AddPostStatus.success;
  bool get isFailure => this == AddPostStatus.failure;
  bool get isUploadingImage => this == AddPostStatus.uploadingImage;
  bool get isSubmitting => this == AddPostStatus.submitting;
  bool get isUploadedImage => this == AddPostStatus.uploadedImage;
}

final class NewPostState {
  final AddPostStatus status;
  final PostTitleField name;
  final PostDescriptionField model;
  final CarPrice price;
  final bool isValid;
  final String toastMessage;

  const NewPostState({

    this.name = const PostTitleField.pure(),
    this.model = const PostDescriptionField.pure(),
    this.price = const CarPrice.pure(),
    this.status = AddPostStatus.initial,
    this.isValid = false,
    this.toastMessage = '',
  });

  NewPostState copyWith({
    AddPostStatus? status,

    PostTitleField? name,
    PostDescriptionField? model,
    CarPrice? price,
    bool? isValid,
    String? toastMessage,
  }) {
    return NewPostState(

      name: name ?? this.name,
      model: model ?? this.model,
      price: price ?? this.price,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }
}
