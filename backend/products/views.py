import os
from django.conf import settings
from django.db.models import Q
from django.shortcuts import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView

from .models import Product


class ProductCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            if not request.user.is_staff:
                return Response(
                    "No tienes permisos para crear productos",
                    status=status.HTTP_403_FORBIDDEN,
                )

            data = request.data
            required_fields = [
                "name",
                "description",
                "price",
                "discount_price",
                "category",
            ]

            missing_fields = [
                field
                for field in required_fields
                if data.get(field) is None or data.get(field) == ""
            ]
            if missing_fields:
                return Response(
                    f"Faltan campos obligatorios: {', '.join(missing_fields)}",
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Validación de precios
            price = float(data.get("price"))
            discount_price = float(data.get("discount_price"))
            if discount_price < 0:
                return Response(
                    "El precio con descuento no puede ser negativo",
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if price < discount_price:
                return Response(
                    "El precio no puede ser menor que el precio con descuento",
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Manejo de imagen
            image_file = request.FILES.get("image")  # imagen enviada
            image_url = "assets/default.png"  # fallback por defecto

            if image_file:
                # Apuntar directo a assets/images
                assets_dir = os.path.join(settings.BASE_DIR, "assets", "images")
                os.makedirs(assets_dir, exist_ok=True)

                image_path = os.path.join(assets_dir, image_file.name)
                with open(image_path, "wb+") as destination:
                    for chunk in image_file.chunks():
                        destination.write(chunk)

                # Guardar la ruta relativa para usarla en la API
                image_url = f"media/{image_file.name}"

            # Crear producto
            Product.objects.create(
                name=data.get("name"),
                description=data.get("description"),
                price=price,
                discount_price=discount_price,
                image_url=image_url,
                category=data.get("category"),
            )

            return Response(
                "Producto creado con éxito",
                status=status.HTTP_201_CREATED,
            )

        except Exception as e:
            return Response(
                str(e),
                status=status.HTTP_400_BAD_REQUEST,
            )


class ProductsAllView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        search_query = request.query_params.get("search", None)

        if search_query:
            products = Product.objects.filter(Q(name__icontains=search_query))
        else:
            products = Product.objects.all()

        products_list = []
        for product in products:
            products_list.append(
                {
                    "id": str(product.id),
                    "name": product.name,
                    "description": product.description,
                    "price": float(product.price),
                    "discount_price": (
                        float(product.discount_price)
                        if product.discount_price
                        else None
                    ),
                    "image_url": (
                        request.build_absolute_uri("/" + product.image_url)
                        if product.image_url
                        else None
                    ),
                    "category": product.category,
                }
            )

        return Response({"products": products_list})


class BulkProductCreateView(APIView):
    def post(self, request):
        try:
            products_data = request.data
            products = []

            for data in products_data:
                product = Product(
                    name=data.get("name"),
                    description=data.get("description"),
                    price=data.get("price"),
                    discount_price=data.get("discount_price"),
                    image_url=data.get("image_url"),
                    category=data.get("category"),
                )
                products.append(product)

            Product.objects.bulk_create(products)

            return Response(
                f"{len(products)} productos creados con éxito",
                status=status.HTTP_201_CREATED,
            )

        except Exception as e:
            return Response(str(e), status=status.HTTP_400_BAD_REQUEST)


class ProductUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request, product_id):
        try:
            if not request.user.is_staff:
                return Response(
                    "No tiene permisos para editar productos.",
                    status=status.HTTP_403_FORBIDDEN,
                )

            product = get_object_or_404(Product, pk=product_id)
            data = request.data

            # Validaciones de campos requeridos
            required_fields = [
                "name",
                "description",
                "price",
                "discount_price",
                "category",
            ]
            missing_fields = [
                field
                for field in required_fields
                if data.get(field) is None or data.get(field) == ""
            ]
            if missing_fields:
                return Response(
                    f"Faltan campos obligatorios: {', '.join(missing_fields)}",
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Validación de precios
            price = float(data.get("price"))
            discount_price = float(data.get("discount_price"))
            if discount_price < 0:
                return Response(
                    "El precio con descuento no puede ser negativo",
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if price < discount_price:
                return Response(
                    "El precio no puede ser menor que el precio con descuento",
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Manejo de imagen
            image_file = request.FILES.get("image")
            if image_file:
                # eliminar la anterior si existe y no es la de fallback
                if product.image_url and product.image_url != "assets/image2.png":
                    old_path = os.path.join(settings.BASE_DIR, product.image_url)
                    if os.path.exists(old_path):
                        os.remove(old_path)

                # guardar nueva imagen en assets/images
                assets_dir = os.path.join(settings.BASE_DIR, "assets", "images")
                os.makedirs(assets_dir, exist_ok=True)

                image_path = os.path.join(assets_dir, image_file.name)
                with open(image_path, "wb+") as destination:
                    for chunk in image_file.chunks():
                        destination.write(chunk)

                product.image_url = f"media/{image_file.name}"

            # Asignar otros valores
            product.name = data.get("name", product.name)
            product.description = data.get("description", product.description)
            product.price = price
            product.discount_price = discount_price
            product.category = data.get("category", product.category)

            product.save()

            return Response(
                "Producto actualizado con éxito",
                status=status.HTTP_200_OK,
            )

        except Exception as e:
            return Response(
                str(e),
                status=status.HTTP_400_BAD_REQUEST,
            )


class ProductDeleteView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, product_id):
        try:
            if not request.user.is_staff:
                return Response(
                    "No tienes permisos para eliminar productos",
                    status=status.HTTP_403_FORBIDDEN,
                )

            product = get_object_or_404(Product, pk=product_id)
            product.delete()
            return Response(
                "Producto eliminado con éxito",
                status=status.HTTP_200_OK,
            )
        except Exception as e:
            return Response(
                str(e),
                status=status.HTTP_400_BAD_REQUEST,
            )
