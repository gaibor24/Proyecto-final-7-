from django.http import JsonResponse
from rest_framework import status


class MiddlewareAuthorization:
    @staticmethod
    def handle_error(response):
        """Maneja errores de autenticación personalizados."""
        try:
            # Extraer el mensaje de error de response.data
            message = response.data.get("detail", "No se proporcionaron credenciales de autenticación.")

            # Reemplazar mensaje si es el de credenciales no proporcionadas
            if message == "Authentication credentials were not provided.":
                message = "No se proporcionaron credenciales de autenticación."

        except AttributeError:
            message = "Error de autenticación."

        return JsonResponse(
            {
                "status": status.HTTP_401_UNAUTHORIZED,
                "message": message,
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )



""" from django.http import JsonResponse
from rest_framework.exceptions import ValidationError
from rest_framework.views import exception_handler
from rest_framework.response import Response
from rest_framework import status


class MiddlewareAuthorization:
    def handle_error(response):
        message = response.data["string"]
        return JsonResponse(
            {
                "status": status.HTTP_401_UNAUTHORIZED,
                "message": message,
            },
            status=status.HTTP_401_UNAUTHORIZED,
        )
 """
