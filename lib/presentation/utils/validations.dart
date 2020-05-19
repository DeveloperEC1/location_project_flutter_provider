class Validations {
  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(value);
  }

  bool validatePassword(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }
}