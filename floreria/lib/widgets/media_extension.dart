enum MediaExtension {
  // Imagen
  jpg,
  jpeg,
  png;

  // Funcion para parsear la enum a cadena
  String toValue() {
    switch (this) {
      // Imagen
      case MediaExtension.jpg:
        return "jpg";
      case MediaExtension.jpeg:
        return "jpeg";
      case MediaExtension.png:
        return "png";
    }
  }
}