from django.urls import path, include

from cart.views import AddToCartView, CartView, UpdateCartItemView, RemoveFromCartView


urlpatterns = [
    path(
        "cart",
        CartView.as_view(),
    ),
    path(
        "cart/add/",
        AddToCartView.as_view(),
        name="cart-add",
    ),
    path(
        "cart/update/<uuid:product_id>/",
        UpdateCartItemView.as_view(),
        name="cart-update",
    ),
    path(
        "cart/remove",
        RemoveFromCartView.as_view(),
        name="cart-remove",
    ),
]
