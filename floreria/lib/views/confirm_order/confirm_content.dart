// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../constants/icons_constants.dart';
import '../../controllers/cart_controller.dart';
import '../../themes/texts_style.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/strings_utils.dart';
import '../../widgets/app_layout.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_cache.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialog_loading.dart';

class ConfirmContent extends StatefulWidget {
  const ConfirmContent({
    super.key,
    required this.total,
    required this.quantity,
  });

  final double total;
  final int quantity;

  @override
  State<ConfirmContent> createState() => _ConfirmContentState();
}

class _ConfirmContentState extends State<ConfirmContent> {
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text('Confirmar pedido')),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 20,
              children: [
                CustomInput(
                  labelText: 'Ciudad',
                  textInputAction: TextInputAction.next,
                  borderColor: AppColors.grisBorder,
                  prefixDynamic: IconsConstants.location,
                  controller: cityController,
                ),
                CustomInput(
                  labelText: 'Provincia',
                  textInputAction: TextInputAction.next,
                  borderColor: AppColors.grisBorder,
                  prefixDynamic: IconsConstants.location,
                  controller: provinceController,
                ),
                CustomInput(
                  labelText: 'Referencia',
                  textInputAction: TextInputAction.next,
                  borderColor: AppColors.grisBorder,
                  prefixDynamic: IconsConstants.location,
                  controller: referenceController,
                ),
                CustomInput(
                  labelText: 'Teléfono',
                  textInputAction: TextInputAction.go,
                  borderColor: AppColors.grisBorder,
                  prefixDynamic: IconsConstants.phone,
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  onCompleted: confirm,
                ),
                SizedBox(),

                _text(
                  icon: IconsConstants.calendar,
                  title: 'Fecha de entrega',
                  value: '10/10/2025',
                ),
                _text(
                  icon: IconsConstants.box,
                  title: 'Monto total',
                  isBold: true,
                  value: StringsUtils.moneyFormat(widget.total),
                ),

                SizedBox(),

                CustomButton(
                  width: MediaQuery.of(context).size.width,
                  value: 'Confirmar Pedido',
                  onTap: confirm,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void confirm() async {
    final cubit = context.read<CartController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const DialogLoading(),
    );

    final value = await cubit.confirmOrder(
      city: cityController.text,
      province: provinceController.text,
      reference: referenceController.text,
      phoneNumber: phoneController.text,
    );

    if (value.isEmpty) {
      if (Navigator.canPop(context)) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AppLayout();
            },
          ),
          (_) => false,
        );
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);

        await SnackBarUtils.snackBarGeneric(context, value: value);
      }
    }
  }

  Widget _text({
    required String icon,
    required String title,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      spacing: 10,
      children: [
        CustomImageCache(url: icon, width: 20, height: 20),
        Expanded(child: Text(title, style: TextsStyle(context).bodySmall)),
        Text(
          value,
          style:
              isBold
                  ? TextsStyle(context).titleMedium.copyWith(fontSize: 17)
                  : TextsStyle(context).bodyMedium,
        ),
      ],
    );
  }
}
