// ignore_for_file: use_build_context_synchronously

import 'package:floreria/controllers/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../status/status_page_value.dart';
import '../../themes/texts_style.dart';
import '../../widgets/handler_error.dart';
import 'users_list.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<UsersController>(context, listen: false).getUsers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UsersController>(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 15,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                'Lista de usuarios',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextsStyle(context).titleMedium,
              ),
              Text(
                'Lista completa de usuarios con sus datos y roles en el sistema.',
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
                    height: size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );

                case StatusPage.empty:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.inventory_2_outlined,
                      text: 'Sin usuarios',
                      onRetry: controller.getUsers,
                    ),
                  );

                case StatusPage.errorConnection:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.wifi_off,
                      text: "No tienes conexión a internet",
                      onRetry: controller.getUsers,
                    ),
                  );

                case StatusPage.errorBackend:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.cloud_off,
                      text: "Error en el servidor, intenta más tarde",
                      onRetry: controller.getUsers,
                    ),
                  );

                case StatusPage.errorApp:
                  return SizedBox(
                    height: size.height * 0.7,
                    child: HandlerError(
                      icon: Icons.bug_report_outlined,
                      text: "Error interno en la aplicación",
                      onRetry: controller.getUsers,
                    ),
                  );

                case StatusPage.success:
                  return UsersList(users: controller.users);

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
