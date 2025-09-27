# middleware_url.py
import json
from django.http import JsonResponse, HttpResponse, JsonResponse
from rest_framework.response import Response
from rest_framework import status


class MiddlewareURL:
    @staticmethod
    def handle_error(response):
        """
        Extrae un mensaje personalizado si existe:
         - si viene de DRF Response => busca 'detail', 'message' o 'error' en response.data
         - si viene de JsonResponse => intenta decodificar contenido JSON
         - si viene de HttpResponse => intenta decodificar JSON del body
        Si no encuentra nada usa el mensaje por defecto.
        """
        message = None

        # 1) DRF Response con .data
        if isinstance(response, Response):
            data = response.data
            if isinstance(data, dict):
                message = data.get("detail") or data.get("message") or data.get("error")
            elif isinstance(data, str):
                message = data

        # 2) JsonResponse de Django
        elif isinstance(response, JsonResponse):
            try:
                data = json.loads(response.content.decode())
                if isinstance(data, dict):
                    message = (
                        data.get("detail") or data.get("message") or data.get("error")
                    )
            except Exception:
                message = None

        # 3) Cualquier HttpResponse (por ejemplo HttpResponseNotFound / HTML)
        elif isinstance(response, HttpResponse):
            # Intentamos parsear JSON si el body contiene JSON
            try:
                raw = response.content.decode()
                parsed = json.loads(raw)
                if isinstance(parsed, dict):
                    message = (
                        parsed.get("detail")
                        or parsed.get("message")
                        or parsed.get("error")
                    )
            except Exception:
                # no es JSON: si response.content es texto corto podemos usarlo, pero generalmente ocultamos HTML
                message = None

        # Fallback al mensaje por defecto
        if not message:
            message = "La URL solicitada no existe."

        return JsonResponse(
            {
                "status": 404,
                "message": message,
            },
            status=status.HTTP_404_NOT_FOUND,
        )
