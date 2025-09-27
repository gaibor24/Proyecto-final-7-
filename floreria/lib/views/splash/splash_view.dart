// ignore_for_file: use_build_context_synchronously

import 'package:floreria/controllers/generic_controller.dart';
import 'package:floreria/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login_view.dart';
import 'splash_content.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<GenericController>(
        context,
        listen: false,
      ).getToken().then((value) async {
        switch (value) {
          case TokenStatus.noTokenExists:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return LoginView();
                },
              ),
              (_) => false,
            );
            break;

          case TokenStatus.tokenExists:
            await context.read<GenericController>().getUser().then((value) {
              if (value != null) {
                context.read<GenericController>().setUser(value);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return AppLayout();
                    },
                  ),
                  (_) => false,
                );
              }
            });
            break;

          default:
            break;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GenericController>(
        builder: (context, controller, _) {
          return SplashContent();
        },
      ),
    );
  }
}
