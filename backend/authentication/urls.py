from django.urls import path
from authentication.views import (
    RegisterUserView,
    LoginUserView,
)

urlpatterns = [
    path("auth/register/", RegisterUserView.as_view()),
    path("auth/login/", LoginUserView.as_view()),
]
