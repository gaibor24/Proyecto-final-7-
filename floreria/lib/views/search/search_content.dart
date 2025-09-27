// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/icons_constants.dart';
import '../../controllers/home_controller.dart';
import '../../status/status_page_value.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/handler_error.dart';
import '../shop/shop_item.dart';

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  TextEditingController queryController = TextEditingController();

  String query = '';

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Column(
      children: [
        SearchAppBar(
          controller: queryController,
          onClear: () async {
            queryController.clear();
            await controller.clearList();
            setState(() {});
          },
          onChange: () {
            setState(() {});
          },
          onCompleted: () async {
            query = queryController.text;
            setState(() {});

            await controller.getProducts(search: queryController.text);
          },
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              switch (controller.statusList) {
                case StatusPage.loading:
                  return SizedBox(
                    height:
                        MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.bottom,
                    child: const Center(child: CircularProgressIndicator()),
                  );

                case StatusPage.empty:
                  return HandlerError(
                    icon: Icons.inventory_2_outlined,
                    text: "No se encontraron\nresultados con $query",
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
                  return GridView.builder(
                    itemCount: controller.products.length,
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.5,
                    ),
                    itemBuilder: (_, i) {
                      final item = controller.products[i];
                      return ShopItem(item: item);
                    },
                  );

                default:
                  return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onCompleted;

  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onCompleted,
    required this.onChange,
  });

  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomInput(
        isBorder: true,
        controller: controller,
        suffixDynamic:
            controller.text.isEmpty ? IconsConstants.search : Icons.close,
        suffixOnTap: controller.text.isEmpty ? null : onClear,
        hintText: 'Buscar',
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.search,
        onChanged: (value, _) {
          onChange.call();
        },
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
