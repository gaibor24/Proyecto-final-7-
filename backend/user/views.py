from django.contrib.auth.models import User
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated


# 🔹 Obtener usuario autenticado
class CurrentUserView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):

        user = request.user

        return Response(
            {
                "user": {
                    "id": user.id,
                    "username": user.first_name,
                    "email": user.email,
                    "is_admin": user.is_staff,
                }
            }
        )


# 🔹 Lista de usuarios (solo admin)
class UsersListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):

        current_user = request.user

        """if not request.user.is_staff:
        return Response("No autorizado", status=403)"""

        users = User.objects.exclude(id=current_user.id)

        data = [
            {
                "id": u.id,
                "username": u.first_name,
                "email": u.email,
                "is_admin": u.is_staff,
            }
            for u in users
        ]

        return Response({"users": data})
