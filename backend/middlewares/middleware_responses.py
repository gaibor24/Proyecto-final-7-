from django.http import JsonResponse


class SuccessResponse200:
    @staticmethod
    def success_response(response):
        data = response.data

        if isinstance(data, dict):
            formatted_data = {
                "status": response.status_code,
                **data,  # Mantiene los datos sin cambios
            }
        elif isinstance(data, str):
            formatted_data = {
                "status": response.status_code,
                "message": data,  # Si es un string, lo encapsula
            }
        elif isinstance(data, list):
            formatted_data = {
                "status": response.status_code,
                "data": data,  # Si es una lista, la coloca en "data"
            }
        else:
            formatted_data = {
                "status": response.status_code,
                "message": "Operación exitosa.",
            }

        # Asegurarse de que la respuesta sea JSON
        return JsonResponse(
            formatted_data,
            status=response.status_code,
            content_type="application/json",
        )
