from django.urls import path, include

from products.views import (
    ProductsAllView,
    ProductCreateView,
    BulkProductCreateView,
    ProductUpdateView,
    ProductDeleteView,
)


urlpatterns = [
    # Products
    path(
        "products",
        ProductsAllView.as_view(),
        name="products_all",
    ),
    # Add Product
    path(
        "products/add/",
        ProductCreateView.as_view(),
        name="add_product",
    ),
    # Add Product
    path(
        "products/update/<uuid:product_id>",
        ProductUpdateView.as_view(),
        name="update_product",
    ),
    # Add Products
    path(
        "products/remove/<uuid:product_id>",
        ProductDeleteView.as_view(),
        name="remove_product",
    ),
    # Add Products
    path(
        "products/add-list/",
        BulkProductCreateView.as_view(),
        name="add_products",
    ),
]
