// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_controller.dart';
import '../../status/status_page_value.dart';
import '../../themes/texts_style.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/handler_error.dart';
import '../add_product/add_product_view.dart';
import 'home_list_product.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<HomeController>(context, listen: false).getProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = Provider.of<HomeController>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'List de productos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextsStyle(context).titleMedium,
                  ),
                ),
                CustomCard(
                  width: 45,
                  height: 45,
                  backgroundColor: Colors.white,
                  isShadow: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProductView()),
                    );
                  },
                  child: Center(child: Icon(Icons.add)),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              switch (controller.statusList) {
                case StatusPage.loading:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );

                case StatusPage.empty:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.inventory_2_outlined,
                      text: "No hay productos disponibles",
                      onRetry: controller.getProducts,
                    ),
                  );

                case StatusPage.errorConnection:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.wifi_off,
                      text: "No tienes conexión a internet",
                      onRetry: controller.getProducts,
                    ),
                  );

                case StatusPage.errorBackend:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.cloud_off,
                      text: "Error en el servidor, intenta más tarde",
                      onRetry: controller.getProducts,
                    ),
                  );

                case StatusPage.errorApp:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.bug_report_outlined,
                      text: "Error interno en la aplicación",
                      onRetry: controller.getProducts,
                    ),
                  );

                case StatusPage.success:
                  return HomeListProduct(
                    list: controller.products,
                    isAdmin: widget.isAdmin,
                  );

                default:
                  return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
