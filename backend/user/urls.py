from django.urls import path
from .views import (
    CurrentUserView,
    UsersListView,
)

urlpatterns = [
    path("user", CurrentUserView.as_view()),
    path("users", UsersListView.as_view()),
]
