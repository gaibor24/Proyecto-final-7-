// ignore_for_file: use_build_context_synchronously

import 'package:floreria/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../constants/icons_constants.dart';
import '../../controllers/register_controller.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/input_validation_type.dart';
import '../login/login_view.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<RegisterController>(
      builder: (context, controller, _) {
        final cubit = context.read<RegisterController>();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              CustomInput(
                labelText: 'Correo',
                prefixDynamic: IconsConstants.email,
                validationType: InputValidationType.requiredEmail,
                borderColor: AppColors.grisBorder,
                onChanged: (value, _) {
                  cubit.changeEmail(value);
                },
              ),

              CustomInput(
                labelText: 'Nombre',
                prefixDynamic: IconsConstants.user,
                keyboardType: TextInputType.name,
                borderColor: AppColors.grisBorder,
                onChanged: (value, _) {
                  cubit.changeName(value);
                },
              ),

              CustomInput(
                labelText: 'Contraseña',
                prefixDynamic: IconsConstants.lock,
                obscureText: true,
                borderColor: AppColors.grisBorder,
                onChanged: (value, _) {
                  cubit.changePassword(value);
                },
              ),

              CheckboxListTile(
                title: Text(
                  'Administrador',
                  style: TextsStyle(context).bodyMedium,
                ),
                value: controller.isAdmin,
                onChanged: (value) {
                  if (value != null) {
                    cubit.changeIsAdmin(value);
                  }
                },
              ),

              SizedBox(),

              CustomButton(
                value: 'Registrarme',
                width: size.width,
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const DialogLoading(),
                  );

                  final value = await cubit.register();

                  if (value.isEmpty) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return LoginView();
                        },
                      ),
                      (_) => false,
                    );
                  } else {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);

                      await SnackBarUtils.snackBarGeneric(
                        context,
                        value: value,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
