from django.urls import path, include

from .views import ConfirmOrderView, OrderListView, OrderDetailView


urlpatterns = [
    path(
        "orders",
        OrderListView.as_view(),
        name="orders",
    ),
    path(
        "orders/confirm/",
        ConfirmOrderView.as_view(),
        name="confirm-order",
    ),
    path(
        "orders/<uuid:order_id>",
        OrderDetailView.as_view(),
        name="order-details",
    ),
]
