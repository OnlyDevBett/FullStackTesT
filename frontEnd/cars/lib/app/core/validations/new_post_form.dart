import 'package:formz/formz.dart';

enum PostCoverValidationError { empty }

enum PostTitleValidationError { empty }

enum PostDescriptionValidationError { empty }

enum CarPriceValidationError { empty }



class PostTitleField extends FormzInput<String, PostTitleValidationError> {
  const PostTitleField.pure([super.value = '']) : super.pure();
  const PostTitleField.dirty([super.value = '']) : super.dirty();

  @override
  PostTitleValidationError? validator(String value) {
    if (value.isEmpty) return PostTitleValidationError.empty;
    return null;
  }
}

class PostDescriptionField
    extends FormzInput<String, PostDescriptionValidationError> {
  const PostDescriptionField.pure([super.value = '']) : super.pure();
  const PostDescriptionField.dirty([super.value = '']) : super.dirty();

  @override
  PostDescriptionValidationError? validator(String value) {
    if (value.isEmpty) return PostDescriptionValidationError.empty;
    return null;
  }
}

class CarPrice
    extends FormzInput<String, CarPriceValidationError> {
  const CarPrice.pure([super.value = '']) : super.pure();
  const CarPrice.dirty([super.value = '']) : super.dirty();

  @override
  CarPriceValidationError? validator(String value) {
    if (value.isEmpty) return CarPriceValidationError.empty;
    return null;
  }
}
