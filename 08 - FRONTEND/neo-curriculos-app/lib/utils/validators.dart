/// Form validation utilities
class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 8) {
      return 'Senha deve ter no mínimo 8 caracteres';
    }

    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Senha deve conter pelo menos uma letra';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Senha deve conter pelo menos um número';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirm(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    if (value.length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }

    return null;
  }

  /// Validate generic text field
  static String? validateRequired(String? value, {String label = 'Campo'}) {
    if (value == null || value.isEmpty) {
      return '$label é obrigatório';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(
    String? value,
    int min, {
    String label = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$label é obrigatório';
    }

    if (value.length < min) {
      return '$label deve ter no mínimo $min caracteres';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(
    String? value,
    int max, {
    String label = 'Campo',
  }) {
    if (value == null || value.isEmpty) {
      return '$label é obrigatório';
    }

    if (value.length > max) {
      return '$label deve ter no máximo $max caracteres';
    }

    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL é obrigatória';
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }

  /// Validate phone number (Brazilian format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove non-digits
    final phoneDigits = value.replaceAll(RegExp(r'\D'), '');

    if (phoneDigits.length < 10 || phoneDigits.length > 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  /// Validate document number (CPF/CNPJ)
  static String? validateDocument(String? value) {
    if (value == null || value.isEmpty) {
      return 'Documento é obrigatório';
    }

    final docDigits = value.replaceAll(RegExp(r'\D'), '');

    if (docDigits.length != 11 && docDigits.length != 14) {
      return 'Documento inválido';
    }

    return null;
  }

  /// Check if email is already in use (would need API call)
  static Future<String?> validateEmailUnique(String? value) async {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailError = validateEmail(value);
    if (emailError != null) {
      return emailError;
    }

    // In real implementation, call API to check uniqueness
    // For now, return null if format is valid
    return null;
  }

  /// Format Brazilian phone number
  static String formatPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    } else if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    }

    return phone;
  }

  /// Format CPF
  static String formatCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 11) {
      return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
    }

    return cpf;
  }
}
