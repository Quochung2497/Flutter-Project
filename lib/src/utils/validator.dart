class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your Email';

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';

    if (value.length < 6) return 'Password must be at least 6 characters';

    final regex =
    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$');
    if (!regex.hasMatch(value)) {
      return 'Password must include:\n'
          ' • at least one uppercase letter\n'
          ' • at least one lowercase letter\n'
          ' • at least one number\n'
          ' • at least one special character';
    }

    return null;
  }
}