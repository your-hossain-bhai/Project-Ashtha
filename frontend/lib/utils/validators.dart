import 'dart:convert';

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  return emailRegex.hasMatch(email);
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!isValidEmail(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  // Add more checks if needed
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  return null;
}

int calculatePasswordStrength(String password) {
  int strength = 0;
  if (password.length >= 8) strength++;
  if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
  if (RegExp(r'[a-z]').hasMatch(password)) strength++;
  if (RegExp(r'[0-9]').hasMatch(password)) strength++;
  if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
  return strength;
}

String getPasswordStrengthText(int strength) {
  switch (strength) {
    case 0:
    case 1:
      return 'Weak';
    case 2:
    case 3:
      return 'Medium';
    case 4:
    case 5:
      return 'Strong';
    default:
      return 'Weak';
  }
}
