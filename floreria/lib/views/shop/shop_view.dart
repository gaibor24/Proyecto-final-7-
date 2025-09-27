// ignore_for_file: use_build_context_synchronously

import 'package:floreria/themes/texts_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../constants/icons_constants.dart';
import '../../controllers/home_controller.dart';
import '../../status/status_page_value.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../../widgets/handler_error.dart';
import '../cart/cart_view.dart';
import 'shop_content.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key, required this.name});

  final String name;

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<HomeController>(context, listen: false).getProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'Hola, ${widget.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextsStyle(context).titleMedium,
                      ),
                      Text(
                        'Descubre los arreglos y detalles que tenemos para ti',
                        style: TextsStyle(
                          context,
                        ).bodySmall.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Builder(
                builder: (context) {
                  switch (controller.statusList) {
                    case StatusPage.loading:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const Center(child: CircularProgressIndicator()),
                      );

                    case StatusPage.empty:
                      return HandlerError(
                        icon: Icons.inventory_2_outlined,
                        text: "No hay productos disponibles",
                        onRetry: controller.getProducts,
                      );

                    case StatusPage.errorConnection:
                      return HandlerError(
                        icon: Icons.wifi_off,
                        text: "No tienes conexión a internet",
                        onRetry: controller.getProducts,
                      );

                    case StatusPage.errorBackend:
                      return HandlerError(
                        icon: Icons.cloud_off,
                        text: "Error en el servidor, intenta más tarde",
                        onRetry: controller.getProducts,
                      );

                    case StatusPage.errorApp:
                      return HandlerError(
                        icon: Icons.bug_report_outlined,
                        text: "Error interno en la aplicación",
                        onRetry: controller.getProducts,
                      );

                    case StatusPage.success:
                      return ShopContent(list: controller.products);

                    default:
                      return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          width: 45,
          height: 45,
          child: CustomCard(
            isShadow: true,
            backgroundColor: Colors.white,
            height: 40,
            width: 40,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartView();
                  },
                ),
              );
            },
            child: Center(
              child: CustomImageCache(
                url: IconsConstants.bag,
                height: 21,
                width: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
