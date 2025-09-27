from decimal import Decimal
from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status

from products.models import Product

from cart.models import Cart


""" class CartView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        cart_items = Cart.objects.filter(user=user)

        if not cart_items.exists():
            return Response(
                {
                    "items": [],
                    "subtotal": 0.0,
                    "discount": 0.0,
                    "tax": 0.0,
                    "shipping": 0.0,
                    "grand_total": 0.0,
                    "currency": "USD",
                },
                status=status.HTTP_200_OK,
            )

        items_data = []
        subtotal = Decimal("0.0")
        discount = Decimal("0.0")

        for item in cart_items:
            product = item.product

            discount_price = product.discount_price or product.price

            item_subtotal = discount_price * item.quantity
            subtotal += item_subtotal
            discount += (product.price - discount_price) * item.quantity

            items_data.append(
                {
                    "id": str(product.id),
                    "name": product.name,
                    "quantity": item.quantity,
                    "price": float(product.price),
                    "discount_price": float(product.discount_price or 0.0),
                    "subtotal": float(item_subtotal),
                    "image_url": (
                        request.build_absolute_uri("/" + product.image_url)
                        if product.image_url
                        else None
                    ),
                    "category": product.category if product.category else None,
                }
            )

        tax = (subtotal * Decimal("0.18")).quantize(Decimal("0.01"))
        shipping = Decimal("10.0")
        grand_total = subtotal + tax + shipping

        return Response(
            {
                "items": items_data,
                "subtotal": float(subtotal),
                "discount": float(discount),
                "tax": float(tax),
                "shipping": float(shipping),
                "grand_total": float(grand_total),
                "currency": "USD",
            },
            status=status.HTTP_200_OK,
        ) """


class CartView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        cart_items = Cart.objects.filter(user=user).select_related("product")

        if not cart_items.exists():
            return Response(
                {
                    "items": [],
                    "subtotal": 0.0,
                    "discount": 0.0,
                    "tax": 0.0,  # impuesto ya incluido en el precio
                    "shipping": 0.0,
                    "grand_total": 0.0,
                    "currency": "USD",
                },
                status=status.HTTP_200_OK,
            )

        items_data = []
        subtotal = Decimal("0.00")
        discount_total = Decimal("0.00")

        for item in cart_items:
            product = item.product
            price = product.price  # Decimal
            discount_price = (
                product.discount_price
                if product.discount_price is not None
                else product.price
            )

            line_subtotal = discount_price * item.quantity
            subtotal += line_subtotal

            line_discount = price - discount_price
            if line_discount > 0:
                discount_total += line_discount * item.quantity

            img = product.image_url
            if img:
                if img.startswith("http://") or img.startswith("https://"):
                    abs_img = img
                else:
                    abs_img = request.build_absolute_uri("/" + img.lstrip("/"))
            else:
                abs_img = None

            items_data.append(
                {
                    "id": str(product.id),
                    "name": product.name,
                    "quantity": item.quantity,
                    "price": float(price),
                    "discount_price": float(product.discount_price or 0.00),
                    "subtotal": float(line_subtotal),
                    "image_url": abs_img,
                    "category": product.category or None,
                }
            )

        shipping = Decimal("10.00")
        grand_total = subtotal + shipping

        return Response(
            {
                "items": items_data,
                "subtotal": float(subtotal),
                "discount": float(discount_total),
                "tax": 0.0,  # impuesto incluido
                "shipping": float(shipping),
                "grand_total": float(grand_total),
                "currency": "USD",
            },
            status=status.HTTP_200_OK,
        )


class AddToCartView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user  # Usuario autenticado
        product_id = request.data.get("product_id")
        quantity = int(request.data.get("quantity", 1))

        try:
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response(
                "El producto no está disponible.",
                status=status.HTTP_404_NOT_FOUND,
            )

        cart_item, created = Cart.objects.get_or_create(
            user=user,
            product=product,
            defaults={"quantity": quantity},
        )

        if not created:
            return Response(
                "El producto ya está en el carrito.",
                status=status.HTTP_200_OK,
            )

        return Response(
            {"message": "Producto agregado al carrito."},
            status=status.HTTP_201_CREATED,
        )


class UpdateCartItemView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request, product_id):
        user = request.user
        quantity = request.data.get("quantity")

        if quantity is None or int(quantity) <= 0:
            return Response(
                "La cantidad debe ser mayor a 0.",
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            cart_item = Cart.objects.get(user=user, product_id=product_id)
        except Cart.DoesNotExist:
            return Response(
                "El producto no está en el carrito.",
                status=status.HTTP_404_NOT_FOUND,
            )

        cart_item.quantity = int(quantity)
        cart_item.save()

        return Response(
            "Cantidad actualizada correctamente",
            status=status.HTTP_200_OK,
        )


class RemoveFromCartView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request):
        user = request.user
        product_id = request.data.get("product_id")

        if not product_id:
            return Response(
                "Debes especificar un producto para eliminar.",
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response(
                "El producto no existe.",
                status=status.HTTP_404_NOT_FOUND,
            )

        try:
            cart_item = Cart.objects.get(user=user, product=product)
        except Cart.DoesNotExist:
            return Response(
                "El producto no está en tu carrito.",
                status=status.HTTP_404_NOT_FOUND,
            )

        cart_item.delete()

        return Response(
            {"message": "Producto eliminado del carrito."},
            status=status.HTTP_200_OK,
        )
