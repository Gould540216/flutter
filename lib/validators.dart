import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  RequiredValidator(errorText: "名前を入力してください"),
  //MaxLengthValidator(5, errorText: "名前は5文字以内で入力してください")
]);
