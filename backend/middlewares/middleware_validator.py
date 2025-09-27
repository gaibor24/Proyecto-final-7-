from django.http import JsonResponse
from rest_framework.response import Response


class MiddlewareValidators:
    @staticmethod
    def handle_error(response: Response):
        """Adapta cualquier respuesta de error personalizada al formato unificado."""

        try:
            data = response.data
            message = None

            if isinstance(data, str):
                message = data

            elif isinstance(data, dict):
                # Detectar 'detail' estándar
                if 'detail' in data:
                    message = str(data['detail'])

                # Verifica si algún campo tiene 'This field is required.'
                elif any(
                    isinstance(v, list) and any("This field is required." in str(i) for i in v)
                    for v in data.values()
                ):
                    message = "Todos los campos son requeridos."

                # Buscar primer mensaje en lista
                elif any(isinstance(v, list) for v in data.values()):
                    for field, messages in data.items():
                        if isinstance(messages, list) and messages:
                            message = str(messages[0])
                            break

                # Buscar primer string plano
                elif any(isinstance(v, str) for v in data.values()):
                    message = next(iter(data.values()))

            elif isinstance(data, list):
                message = str(data[0]) if data else None

            if not message:
                message = "Ocurrió un error en la solicitud."

            status_code = response.status_code or 400

        except Exception as e:
            message = "Error desconocido"
            status_code = 500

        return JsonResponse(
            {
                "status": status_code,
                "message": message,
            },
            status=status_code,
        )




""" from django.http import JsonResponse
from rest_framework import status


class MiddlewareValidators:
    @staticmethod
    def handle_error(response):
        try:
            errors = response.data
            message = None

            # Si los errores son un diccionario (errores por campo)
            if isinstance(errors, dict):
                for field, messages in errors.items():
                    if isinstance(messages, list) and messages:
                        message = str(
                            messages[0]
                        )  # Tomamos el primer mensaje disponible
                        break  # Solo tomamos el primer error encontrado

            # Si los errores son una lista (error general)
            elif isinstance(errors, list) and errors:
                message = str(errors[0])

            # Si no se encuentra ningún mensaje específico, ponemos un mensaje por defecto
            if not message:
                message = "Los datos proporcionados son inválidos."

        except Exception as e:
            print(e)
            # Si ocurre un error inesperado en el manejo, devolver un mensaje genérico
            message = "Error desconocido"

        # Enviar la respuesta personalizada
        return JsonResponse(
            {
                "status": 400,
                "message": message,
            },
            status=status.HTTP_400_BAD_REQUEST,
        ) """


""" from django.http import JsonResponse
from rest_framework import status


class MiddlewareValidators:
    @staticmethod
    def handle_error(response):
        errors = response.data
        message = None

        # Si los errores son un diccionario (errores por campo)
        if isinstance(errors, dict):
            for field, messages in errors.items():
                if isinstance(messages, list) and messages:
                    message = str(messages[0])  # Tomamos el primer mensaje disponible
                    break  # Solo tomamos el primer error encontrado

        # Si los errores son una lista (error general)
        elif isinstance(errors, list) and errors:
            message = str(errors[0])

        # Si no se encuentra ningún mensaje específico, ponemos un mensaje por defecto
        if not message:
            message = "Los datos proporcionados son inválidos."

        # Enviar la respuesta personalizada
        return JsonResponse(
            {
                "status": 400,
                "message": message,
            },
            status=status.HTTP_400_BAD_REQUEST,
        ) """
