import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/register_controller.dart';
import 'register_content.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => RegisterController(),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(title: Text('Crear nuevo usuario')),
              RegisterContent(),
            ],
          ),
        ),
      ),
    );
  }
}
