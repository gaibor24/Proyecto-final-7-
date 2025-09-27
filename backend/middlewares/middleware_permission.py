from django.http import JsonResponse
from rest_framework import status


class MiddlewarePermission:
    @staticmethod
    def handle_error(response):
        """Maneja los errores 403 Forbidden con un mensaje personalizado."""
        return JsonResponse(
            {
                "status": 403,
                "message": "No tienes permisos para realizar esta acción.",
            },
            status=status.HTTP_403_FORBIDDEN,
        )
