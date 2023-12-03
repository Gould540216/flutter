import 'package:form_field_validator/form_field_validator.dart';

class UrlValidator extends TextFieldValidator {
  UrlValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9./:!#$&¥%&'*+-=?^_'{|}~]+$")
          .hasMatch(value!);
}
