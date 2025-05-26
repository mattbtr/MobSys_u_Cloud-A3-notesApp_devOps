class Validator {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'E-Mail darf nicht leer sein';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Ungültige E-Mail-Adresse';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Passwort darf nicht leer sein';
    }
    if (password.length < 6) {
      return 'Passwort muss mindestens 6 Zeichen lang sein';
    }
    return null;
  }
}
