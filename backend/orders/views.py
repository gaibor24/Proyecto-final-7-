from decimal import Decimal
from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from django.db import transaction

from cart.models import Cart
from orders.models import Order, OrderItem


class ConfirmOrderView(APIView):
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        user = request.user
        cart_items = Cart.objects.filter(user=user)

        if not cart_items.exists():
            return Response(
                "Tu carrito está vacío.",
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Datos de envío desde el frontend
        city = request.data.get("city")
        province = request.data.get("province")
        reference = request.data.get("reference", "")
        phone_number = request.data.get("phone_number")

        # Validar campos obligatorios
        if not city or not province or not phone_number:
            return Response(
                {"message": "Todos los campos son obligatorios."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Crear orden
        order = Order.objects.create(
            user=user,
            city=city,
            province=province,
            reference=reference,
            phone_number=phone_number,
            country_code="+593",
        )

        delivery = 10
        total = 0

        for item in cart_items:
            price = item.product.discount_price or item.product.price
            total += price * item.quantity

            OrderItem.objects.create(
                order=order,
                product=item.product,
                quantity=item.quantity,
                price=price,
            )

        order.total_amount = total + delivery
        order.status = "confirmed"
        order.save()

        # Vaciar carrito
        cart_items.delete()

        return Response(
            {
                "message": "Pedido confirmado con éxito.",
                "total_amount": str(order.total_amount),
                "order_id": str(order.id),
            },
            status=status.HTTP_201_CREATED,
        )


class OrderListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        if user.is_staff:
            orders = Order.objects.all().order_by("-created_at")
        else:
            orders = Order.objects.filter(user=user).order_by("-created_at")

        status_mapping = {
            "pending": "Pendiente",
            "confirmed": "Confirmado",
            "cancelled": "Cancelado",
        }

        data = [
            {
                "id": order.id,
                "user": {
                    "username": order.user.first_name,
                    "email": order.user.email,
                },
                "total_amount": float(order.total_amount),
                "status": status_mapping.get(order.status, order.status),
                "created_at": order.created_at,
            }
            for order in orders
        ]

        return Response({"orders": data}, status=status.HTTP_200_OK)


class OrderDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, order_id):
        user = request.user

        try:
            if user.is_staff:
                order = get_object_or_404(Order, id=order_id)
            else:
                order = get_object_or_404(Order, id=order_id, user=user)
        except:
            return Response(
                f"El pedido con ID {order_id} no fue encontrado.",
                status=status.HTTP_404_NOT_FOUND,
            )

        items_qs = OrderItem.objects.select_related("product").filter(order=order)

        subtotal = Decimal("0.00")
        discount_total = Decimal("0.00")
        items = []

        for oi in items_qs:
            line_subtotal = Decimal(oi.price) * oi.quantity
            subtotal += line_subtotal

            # Si el producto tenía precio original mayor, calculamos ahorro
            if oi.product and oi.product.price is not None:
                original = oi.product.price
                paid = Decimal(oi.price)
                if original > paid:
                    discount_total += (original - paid) * oi.quantity

            img = oi.product.image_url if oi.product else None
            if img:
                if img.startswith("http://") or img.startswith("https://"):
                    abs_img = img
                else:
                    abs_img = request.build_absolute_uri("/" + img.lstrip("/"))
            else:
                abs_img = None

            items.append(
                {
                    "product_name": oi.product.name if oi.product else "",
                    "quantity": oi.quantity,
                    "price": float(oi.price),
                    "subtotal": float(line_subtotal),
                    "image_url": abs_img,
                    "category": (
                        oi.product.category
                        if oi.product and oi.product.category
                        else None
                    ),
                }
            )

        status_mapping = {
            "pending": "Pendiente",
            "confirmed": "Confirmado",
            "cancelled": "Cancelado",
        }

        shipping = Decimal("10.00")
        grand_total = subtotal + shipping

        order_data = {
            "id": order.id,
            "subtotal": float(subtotal),
            "discount": float(discount_total),
            "shipping": float(shipping),
            "grand_total": float(grand_total),
            "status": status_mapping.get(order.status, order.status),
            "created_at": order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        }

        user_data = {
            "username": order.user.first_name,
            "email": order.user.email,
        }

        return Response(
            {
                "order": order_data,
                "user": user_data,
                "items": items,
            },
            status=status.HTTP_200_OK,
        )
