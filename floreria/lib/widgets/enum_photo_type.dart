enum EnumPhotoType {
  camera,
  gallery;

  String get value {
    switch (this) {
      case camera:
        return 'camera';

      case gallery:
        return 'gallery';
    }
  }
}
