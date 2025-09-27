// ignore_for_file: use_build_context_synchronously

import 'package:floreria/themes/texts_style.dart';
import 'package:floreria/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/generic_controller.dart';
import '../splash/splash_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GenericController>(context);

    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Correo: ${controller.user?.email ?? ''}',
                style: TextsStyle(context).bodyMedium,
              ),

              Text(
                'Nombre: ${controller.user?.name ?? ''}',
                style: TextsStyle(context).bodyMedium,
              ),

              Expanded(
                child: Center(
                  child: CustomButton(
                    width: MediaQuery.of(context).size.width,
                    value: 'Cerrar Sesion',
                    onTap: () async {
                      await context.read<GenericController>().logout().then((
                        value,
                      ) {
                        if (value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return SplashView();
                              },
                            ),
                            (_) => false,
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
