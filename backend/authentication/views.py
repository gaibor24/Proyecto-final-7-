import uuid
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken


# 🔹 Registro de usuario
class RegisterUserView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        data = request.data
        name = data.get("name")
        email = data.get("email")
        password = data.get("password")
        is_admin = data.get("is_admin", False)

        if not name or not email or not password:
            return Response(
                "Todos los campos son requeridos",
                status=status.HTTP_400_BAD_REQUEST,
            )

        if User.objects.filter(email=email).exists():
            return Response(
                "Este correo ya se encuentra en uso",
                status=status.HTTP_400_BAD_REQUEST,
            )

        unique_username = f"user_{uuid.uuid4().hex[:10]}"

        user = User.objects.create_user(
            username=unique_username,
            email=email,
            password=password,
            first_name=name,
            is_staff=is_admin,
        )

        return Response(
            {
                "user": {
                    "id": user.id,
                    "name": user.first_name,
                    "email": user.email,
                    "is_admin": user.is_staff,
                }
            },
            status=status.HTTP_201_CREATED,
        )


# 🔹 Inicio de sesión
class LoginUserView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")

        if not email or not password:
            return Response(
                "Correo y contraseña requeridos",
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            user_obj = User.objects.get(email=email)
        except User.DoesNotExist:
            return Response(
                "Credenciales inválidas",
                status=status.HTTP_400_BAD_REQUEST,
            )

        user = authenticate(username=user_obj.username, password=password)

        if user is None:
            return Response(
                "Credenciales inválidas",
                status=status.HTTP_400_BAD_REQUEST,
            )

        refresh = RefreshToken.for_user(user)
        access_token = str(refresh.access_token)

        return Response(
            {
                "message": "Inicio de sesión exitoso.",
                "access_token": access_token,
                "refresh_token": str(refresh),
            },
            status=status.HTTP_200_OK,
        )

        """ return Response(
            {
                "user": {
                    "id": user.id,
                    "name": user.first_name,
                    "email": user.email,
                    "is_admin": user.is_staff,
                }
            },
            status=status.HTTP_200_OK,
        ) """
