enum InputValidationType {
  none,
  required,
  email,
  requiredEmail,
  rut,
  requiredRut,
  requiredMinLength,
  requiredEmailMinLength,
  password,
  requiredPassword,
  url,
  requiredUrl;

  /// Retorna `null` si es válido, o el mensaje de error si no lo es.
  String? validate(String value, {int? minLength}) {
    final trimmed = value.trim();

    switch (this) {
      case InputValidationType.required:
        return trimmed.isEmpty ? 'El campo es requerido' : null;

      case InputValidationType.email:
        return trimmed.isNotEmpty && !_isValidEmail(trimmed)
            ? 'Correo inválido'
            : null;

      case InputValidationType.requiredEmail:
        if (trimmed.isEmpty) return 'El campo es requerido';
        return !_isValidEmail(trimmed) ? 'Correo inválido' : null;

      case InputValidationType.rut:
        return trimmed.isEmpty
            ? null
            : (!_isValidRut(trimmed) ? 'RUT inválido' : null);

      case InputValidationType.requiredRut:
        if (trimmed.isEmpty) return 'El campo es requerido';
        return !_isValidRut(trimmed) ? 'RUT inválido' : null;

      case InputValidationType.requiredMinLength:
        if (trimmed.isEmpty) return 'El campo es requerido';
        if (minLength != null && trimmed.length < minLength) {
          return 'Mínimo $minLength caracteres';
        }
        return null;

      case InputValidationType.requiredEmailMinLength:
        if (trimmed.isEmpty) return 'El campo es requerido';
        if (!_isValidEmail(trimmed)) return 'Correo inválido';
        if (minLength != null && trimmed.length < minLength) {
          return 'Mínimo $minLength caracteres';
        }
        return null;

      case InputValidationType.password:
        return trimmed.isNotEmpty && !_isStrongPassword(trimmed)
            ? 'Contraseña débil (min 6 caracteres, letras y números)'
            : null;

      case InputValidationType.requiredPassword:
        if (trimmed.isEmpty) return 'El campo es requerido';
        return !_isStrongPassword(trimmed)
            ? 'Contraseña débil (min 6 caracteres, letras y números)'
            : null;

      case InputValidationType.url:
        return trimmed.isNotEmpty && !_isValidUrl(trimmed)
            ? 'URL inválida'
            : null;

      case InputValidationType.requiredUrl:
        if (trimmed.isEmpty) return 'El campo es requerido';
        return !_isValidUrl(trimmed) ? 'URL inválida' : null;

      case InputValidationType.none:
        return null;
    }
  }

  /// Devuelve `true` si es válido
  bool isValid(String value, {int? minLength}) {
    return validate(value, minLength: minLength) == null;
  }

  static bool _isValidEmail(String input) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(input);
  }

  static bool _isStrongPassword(String input) {
    return input.length >= 6 &&
        RegExp(r'[a-zA-Z]').hasMatch(input) &&
        RegExp(r'\d').hasMatch(input);
  }

  static bool _isValidUrl(String input) {
    final urlPattern = RegExp(
      r'^(https?:\/\/)' // Protocolo obligatorio
      r'((([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}))' // Dominio
      r'(:\d+)?' // Puerto opcional
      r'(\/[^\s]*)?$', // Ruta y query opcionales
      caseSensitive: false,
    );

    return urlPattern.hasMatch(input);
  }

  static bool _isValidRut(String rut) {
    // Limpieza: eliminar puntos, guiones, espacios y convertir a mayúsculas
    final cleanRut = rut.replaceAll(RegExp(r'[^0-9kK]'), '').toUpperCase();
    if (cleanRut.length < 2) return false;

    final digits = cleanRut.substring(0, cleanRut.length - 1);
    final checkDigit = cleanRut[cleanRut.length - 1];

    if (!RegExp(r'^\d+$').hasMatch(digits)) return false;

    int sum = 0;
    int multiplier = 2;

    for (int i = digits.length - 1; i >= 0; i--) {
      sum += int.parse(digits[i]) * multiplier;
      multiplier = multiplier == 7 ? 2 : multiplier + 1;
    }

    final mod11 = 11 - (sum % 11);
    final expected =
        (mod11 == 11)
            ? '0'
            : (mod11 == 10)
            ? 'K'
            : mod11.toString();

    return expected == checkDigit;
  }
}
