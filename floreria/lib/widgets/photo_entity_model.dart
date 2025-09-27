import 'dart:io';
import 'package:http/http.dart';
import 'enum_photo_type.dart';

class PhotoEntityModel {
  final String? id;
  final String? created;
  final File? file;
  final EnumPhotoType? type;

  const PhotoEntityModel({
    this.id,
    this.created,
    this.file,
    this.type,
  });

  /// Convierte la foto en un mapa listo para enviar en un multipart request.
  Future<Map<String, dynamic>> imageJson() async {
    if (file == null) {
      throw Exception("No se ha proporcionado un archivo para la imagen.");
    }

    final fileName = file!.path.split('/').last;

    return {
      'url': await MultipartFile.fromPath(
        'url', // clave del campo que espera el backend
        file!.path,
        filename: fileName,
      ),
      'image_type': type?.value,
    };
  }
}
