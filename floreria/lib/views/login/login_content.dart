// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../constants/icons_constants.dart';
import '../../controllers/login_controller.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/input_validation_type.dart';
import '../register/register_view.dart';
import '../splash/splash_view.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Consumer<LoginController>(
      builder: (context, controller, _) {
        final cubit = context.read<LoginController>();

        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height - padding.bottom,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        spacing: 3,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¡Qué gusto tenerte aquí!',
                            style: TextsStyle(context).titleMedium,
                          ),
                          Text(
                            'Inicia sesión para seguir disfrutando de nuestras flores.',
                            style: TextsStyle(context).hint,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 15,
                        children: [
                          CustomInput(
                            labelText: 'Correo',
                            keyboardType: TextInputType.emailAddress,
                            prefixDynamic: IconsConstants.email,
                            validationType: InputValidationType.requiredEmail,
                            borderColor: AppColors.grisBorder,
                            onChanged: (value, _) {
                              cubit.changeEmail(value);
                            },
                          ),

                          CustomInput(
                            labelText: 'Contraseña',
                            prefixDynamic: IconsConstants.lock,
                            validationType: InputValidationType.required,
                            obscureText: true,
                            borderColor: AppColors.grisBorder,
                            onChanged: (value, _) {
                              cubit.changePassword(value);
                            },
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextsStyle(context).bodySmall,
                              ),
                            ),
                          ),

                          SizedBox(),

                          CustomButton(
                            value: 'Ingresar',
                            width: size.width,
                            isOnTap:
                                controller.email.isNotEmpty &&
                                controller.password.isNotEmpty,
                            onTap: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const DialogLoading(),
                              );

                              final value = await cubit.loginUser();

                              if (value.isEmpty) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return SplashView();
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

                          CustomButton(
                            value: 'Crear nuevo usuario',
                            backgroundColor: Colors.amberAccent.shade100,
                            textColor: Colors.black,
                            icon: Icons.person_add_alt_1,
                            width: size.width,
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return RegisterView();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
