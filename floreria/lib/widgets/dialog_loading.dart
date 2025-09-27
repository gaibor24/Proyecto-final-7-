// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DialogLoading extends StatefulWidget {
  const DialogLoading({super.key});

  @override
  State<DialogLoading> createState() => _DialogLoadingState();

  static Widget loadingWidget(context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _DialogLoadingState extends State<DialogLoading> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        // backgroundColor: Theme.of(context).cardColor,
        // surfaceTintColor: Theme.of(context).cardColor,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogLoading.loadingWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
