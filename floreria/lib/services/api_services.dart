import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/api_model.dart';
import '../services/token_services.dart';

/// Enum para los métodos HTTP
enum HttpMethod {
  get,
  post,
  put,
  delete;

  String get value {
    switch (this) {
      case post:
        return 'POST';

      case put:
        return 'PUT';

      default:
        return '';
    }
  }
}

class ApiServices {
  /// Método genérico para llamadas HTTP
  static Future<ApiModel<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params, // ✅ parámetros opcionales
    File? file, // ✅ Nuevo: archivo opcional para multipart
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final token = await TokenServices().getToken() ?? '';

    // ✅ Construimos la URL con parámetros
    Uri url = Uri.parse('${ApiConstants.url}/$endpoint');
    if (params != null && params.isNotEmpty) {
      url = url.replace(
        queryParameters: {
          ...url.queryParameters,
          ...params.map((key, value) => MapEntry(key, value.toString())),
        },
      );
    }

    try {
      late http.Response response;

      final headers = <String, String>{};
      if (token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      // ✅ Si hay archivo -> multipart
      if (file != null &&
          (method == HttpMethod.post || method == HttpMethod.put)) {
        final request = http.MultipartRequest(method.value, url);

        request.headers.addAll(headers);

        print(body);

        // Campos normales
        if (body != null) {
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        // Archivo
        request.files.add(
          await http.MultipartFile.fromPath("image", file.path),
        );

        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // ✅ Request normal (JSON)
        final jsonHeaders = {...headers, "Content-Type": "application/json"};

        switch (method) {
          case HttpMethod.post:
            print('$url // $body');
            response = await http.post(
              url,
              headers: jsonHeaders,
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case HttpMethod.put:
            response = await http.put(
              url,
              headers: jsonHeaders,
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case HttpMethod.delete:
            response = await http.delete(
              url,
              headers: jsonHeaders,
              body: body != null ? jsonEncode(body) : null,
            );
            break;
          case HttpMethod.get:
            response = await http.get(url, headers: jsonHeaders);
            break;
        }
      }

      final decodedBody =
          response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedBody is Map<String, dynamic>) {
          return ApiModel<T>(success: true, data: fromJson(decodedBody));
        } else {
          return ApiModel<T>(
            success: true,
            message: "Respuesta no es un objeto JSON esperado",
          );
        }
      } else {
        // ✅ Mejor manejo de errores
        String errorMessage = "Error ${response.statusCode}";
        if (decodedBody is Map<String, dynamic>) {
          errorMessage =
              decodedBody["message"] ??
              decodedBody["detail"] ??
              decodedBody.toString();
        } else if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }

        return ApiModel<T>(success: false, message: errorMessage);
      }
    } catch (e) {
      return ApiModel<T>(
        success: false,
        message: 'Ocurrió un error en el servidor',
      );
    }
  }
}
