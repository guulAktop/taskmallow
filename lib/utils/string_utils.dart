extension StringUtils on String {
  String camelCaseToKebabCase() {
    String value = "";
    for (var i = 0; i < length; i++) {
      if (i != 0 && this[i] == this[i].toUpperCase()) {
        value += "-";
      }
      value += this[i].toLowerCase();
    }

    return value;
  }

  String toSnackCase(String input) {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    List<String> words = input.split(exp);
    return words.join('_').toLowerCase();
  }
}
