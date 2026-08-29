
class Validators {
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'The password must be at least 8 characters long.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'It must contain at least one capital letter.';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'It must contain at least one number';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'The email format is incorrect.';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'please enter your name';
    return null;
  }
}