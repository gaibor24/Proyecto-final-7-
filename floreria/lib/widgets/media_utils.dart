import 'dart:io';
import 'package:floreria/widgets/photo_entity_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/snackbar_utils.dart';
import 'enum_photo_type.dart';
import 'media_extension.dart';

class MediaUtils {
  Future<void> getImageFromCamera(
    BuildContext context, {
    required Function(PhotoEntityModel) onGetImage,
    List<MediaExtension> allowedExtensions = const [
      MediaExtension.jpg,
      MediaExtension.jpeg,
      MediaExtension.png,
    ],
  }) async {
    final ImagePicker picker = ImagePicker();

    // Verificar permisos de cámara
    if (!await Permission.camera.isGranted) {
      final permissionStatus = await Permission.camera.request();
      if (!permissionStatus.isGranted) {
        if (context.mounted) {
          SnackBarUtils.snackBarGeneric(
            context,
            title: '',
            value: 'Camera access is denied.',
          );
        }
        return;
      }
    }

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        if (context.mounted) {
          SnackBarUtils.snackBarGeneric(
            context,
            title: '',
            value: 'No file selected.',
          );
        }
        return;
      }

      final extension = pickedFile.path.split('.').last.toLowerCase();
      final allowedExtensionValues =
          allowedExtensions.map((e) => e.toValue().toLowerCase()).toSet();

      if (allowedExtensionValues.contains(extension)) {
        final file = File(pickedFile.path);
        final photo = PhotoEntityModel(
          file: file,
          type: EnumPhotoType.camera,
          created: DateTime.now().toIso8601String(),
          id: DateTime.now().toIso8601String(),
        );
        onGetImage(photo);
      } else if (context.mounted) {
        await SnackBarUtils.snackBarGeneric(
          context,
          title: '',
          value: 'File extension not allowed.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        await SnackBarUtils.snackBarGeneric(
          context,
          title: 'Error taking photo',
          value: e.toString(),
        );
      }
    }
  }

  Future<void> getImageFromGallery(
    BuildContext context, {
    required Function(PhotoEntityModel) onGetImage,
    List<MediaExtension> allowedExtensions = const [
      MediaExtension.jpg,
      MediaExtension.jpeg,
      MediaExtension.png,
    ],
  }) async {
    final ImagePicker picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        if (context.mounted) {
          SnackBarUtils.snackBarGeneric(
            context,
            title: '',
            value: 'No file selected.',
          );
        }
        return;
      }

      final extension = pickedFile.path.split('.').last.toLowerCase();
      final allowedExtensionValues =
          allowedExtensions.map((e) => e.toValue().toLowerCase()).toSet();

      if (allowedExtensionValues.contains(extension)) {
        final file = File(pickedFile.path);
        final photo = PhotoEntityModel(
          file: file,
          type: EnumPhotoType.gallery,
          id: DateTime.now().toIso8601String(),
        );
        onGetImage(photo);
      } else if (context.mounted) {
        SnackBarUtils.snackBarGeneric(
          context,
          title: '',
          value: 'File extension not allowed.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.snackBarGeneric(
          context,
          title: '',
          value: 'Error selecting image: ${e.toString()}',
        );
      }
    }
  }
}
