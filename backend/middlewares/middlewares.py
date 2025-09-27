# middleware.py
import json
from django.http import JsonResponse, HttpResponse, JsonResponse
from rest_framework.response import Response
from rest_framework import status

from .middleware_permission import MiddlewarePermission
from .middleware_responses import SuccessResponse200
from .middleware_authorization import MiddlewareAuthorization
from .middleware_url import MiddlewareURL
from .middleware_validator import MiddlewareValidators


class HandleMiddlewares:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        try:
            response = self.get_response(request)
        except Exception as e:
            # cualquier excepción no capturada
            return JsonResponse(
                {
                    "status": 500,
                    "message": "Error interno del servidor",
                    "detail": str(e),
                },
                status=500,
            )

        # --- SAFE: no acceder a response.data sin comprobar ---
        parsed_data = None
        # DRF Response
        if isinstance(response, Response):
            parsed_data = response.data
        # JsonResponse (Django)
        elif isinstance(response, JsonResponse):
            try:
                parsed_data = json.loads(response.content.decode())
            except Exception:
                parsed_data = None
        # Otro HttpResponse con body JSON posible
        elif isinstance(response, HttpResponse):
            try:
                parsed_data = json.loads(response.content.decode())
            except Exception:
                parsed_data = None

        # DEBUG-safe print
        """ try:
            # Imprime algo razonable sin lanzar excepción
            print("response.status_code=", getattr(response, "status_code", None))
            if parsed_data is not None:
                print("response.data=", parsed_data)
        except Exception:
            pass """

        # Manejo según status
        status_code = getattr(response, "status_code", None)

        # Success 200/201 (solo si es DRF Response)
        if status_code in (200, 201) and isinstance(response, Response):
            return SuccessResponse200.success_response(response)

        # Validaciones / Bad Request / etc.
        if status_code in (400, 422, 410, 429):
            return MiddlewareValidators.handle_error(response)

        if status_code == 401:
            return MiddlewareAuthorization.handle_error(response)

        if status_code == 403:
            return MiddlewarePermission.handle_error(response)

        # 404 -> usar MiddlewareURL que maneja Response y HttpResponse
        if status_code == 404:
            return MiddlewareURL.handle_error(response)

        if status_code == 500:
            return JsonResponse(
                {
                    "status": 500,
                    "message": "Error interno del servidor",
                },
                status=500,
            )

        return response


""" # middleware.py
from django.http import JsonResponse
from rest_framework.response import Response
from django.urls import resolve
from django.conf import settings

from .middleware_permission import MiddlewarePermission
from .middleware_responses import SuccessResponse200
from .middleware_authorization import MiddlewareAuthorization
from .middleware_url import MiddlewareURL
from .middleware_validator import MiddlewareValidators


class HandleMiddlewares:

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        try:
            # Llamamos al siguiente middleware o la vista
            response = self.get_response(request)

            print(f'response == {response.data}')

            if response.status_code in [200, 201] and isinstance(response, Response):
                return SuccessResponse200.success_response(response)

            # Si es un error 400 (por validaciones fallidas u otros), simplemente lo interceptamos
            if response.status_code in [400, 422, 410, 429]:
                return MiddlewareValidators.handle_error(response)

            # Si es un error 401 por autorizacion
            if response.status_code == 401:
                return MiddlewareAuthorization.handle_error(response)

            # Si es un error 403 por permisos
            if response.status_code == 403:
                return MiddlewarePermission.handle_error(response)

            # Si la respuesta es un error 404, la interceptamos y devolvemos un mensaje customizado
            if response.status_code == 404:
                return MiddlewareURL.handle_error(response)

            if response.status_code == 500:
                return JsonResponse(
                    {
                        "status": 500,
                        "message": "Error interno del servidor",
                    },
                    status=500,
                )

            return response

        except Exception as e:
            return JsonResponse(
                {
                    "status": 500,
                    "message": "Error interno del servidor",
                    "detail": str(e),  # Muestra detalles solo en modo DEBUG
                },
                status=500,
            ) """
