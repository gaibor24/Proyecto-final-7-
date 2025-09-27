// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../controllers/orders_controller.dart';
import '../../status/status_page_value.dart';
import '../../themes/texts_style.dart';
import '../../widgets/handler_error.dart';
import 'orders_list.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<OrdersController>(context, listen: false).getOrders(),
    );
  }

  String get title {
    if (widget.isAdmin) {
      return 'Lista de pedidos';
    } else {
      return 'Mis Pedidos';
    }
  }

  String get subTitle {
    if (widget.isAdmin) {
      return 'Control central de todos los pedidos activos e históricos';
    } else {
      return 'Gestiona tus pedidos, consulta su estado y revisa los detalles fácilmente.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrdersController>(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextsStyle(context).titleMedium,
              ),
              Text(
                subTitle,
                style: TextsStyle(
                  context,
                ).bodySmall.copyWith(color: AppColors.grey),
              ),
            ],
          ),

          Builder(
            builder: (context) {
              switch (controller.status) {
                case StatusPage.loading:
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: CircularProgressIndicator()),
                  );

                case StatusPage.empty:
                  return HandlerError(
                    icon: Icons.inventory_2_outlined,
                    text: "No hay pedidos",
                    onRetry: controller.getOrders,
                  );

                case StatusPage.errorConnection:
                  return HandlerError(
                    icon: Icons.wifi_off,
                    text: "No tienes conexión a internet",
                    onRetry: controller.getOrders,
                  );

                case StatusPage.errorBackend:
                  return HandlerError(
                    icon: Icons.cloud_off,
                    text: "Error en el servidor, intenta más tarde",
                    onRetry: controller.getOrders,
                  );

                case StatusPage.errorApp:
                  return HandlerError(
                    icon: Icons.bug_report_outlined,
                    text: "Error interno en la aplicación",
                    onRetry: controller.getOrders,
                  );

                case StatusPage.success:
                  return OrdersList(orders: controller.order?.orders ?? []);

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
