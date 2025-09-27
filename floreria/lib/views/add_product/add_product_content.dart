// ignore_for_file: use_build_context_synchronously

import 'package:floreria/widgets/app_layout.dart';
import 'package:floreria/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors/app_colors.dart';
import '../../controllers/add_product_controller.dart';
import '../../models/products/product_item_model.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_image_cache.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialog_loading.dart';
import '../../widgets/input_validation_type.dart';
import '../../widgets/media_utils.dart';
import '../../widgets/photo_entity_model.dart';

class AddProductContent extends StatefulWidget {
  const AddProductContent({super.key, this.product});

  final ProductItemModel? product;

  @override
  State<AddProductContent> createState() => _AddProductContentState();
}

class _AddProductContentState extends State<AddProductContent> {
  PhotoEntityModel? photo;

  String get textButton {
    if (widget.product != null) {
      return 'Editar producto';
    } else {
      return 'Crear nuevo producto';
    }
  }

  String? get imageUrl {
    if (photo != null) {
      return null;
    } else if (widget.product != null) {
      return widget.product?.imageUrl ?? '';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = context.read<AddProductController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        spacing: 20,
        children: [
          if (imageUrl == null && photo == null)
            CustomCard(
              width: size.width * 0.4,
              height: size.width * 0.5,
              backgroundColor: AppColors.grisSuave,
              child: Center(child: Icon(Icons.add)),
              onTap: () async {
                await MediaUtils().getImageFromGallery(
                  context,
                  onGetImage: (value) {
                    photo = value;
                    setState(() {});
                  },
                );
              },
            ),

          if (imageUrl != null)
            CustomCard(
              width: size.width * 0.4,
              height: size.width * 0.5,
              child: CustomImageCache(
                url: imageUrl!,
                width: size.width * 0.4,
                height: size.width * 0.5,
                fit: BoxFit.contain,
              ),
              onTap: () async {
                await MediaUtils().getImageFromGallery(
                  context,
                  onGetImage: (value) {
                    photo = value;
                    setState(() {});
                  },
                );
              },
            ),

          if (photo != null)
            CustomCard(
              width: size.width * 0.4,
              height: size.width * 0.5,
              child: Image.file(
                photo!.file!,
                fit: BoxFit.contain,
                width: size.width * 0.4,
                height: size.width * 0.5,
              ),
              onTap: () async {
                await MediaUtils().getImageFromGallery(
                  context,
                  onGetImage: (value) {
                    photo = value;
                    setState(() {});
                  },
                );
              },
            ),

          CustomInput(
            labelText: 'Nombre',
            value: widget.product?.name ?? '',
            borderColor: AppColors.grisBorder,
            validationType: InputValidationType.required,
            onChanged: (value, _) {
              cubit.onChangeName(value);
            },
          ),

          CustomInput(
            labelText: 'Categoria',
            value: widget.product?.category ?? '',
            borderColor: AppColors.grisBorder,
            validationType: InputValidationType.required,
            onChanged: (value, _) {
              cubit.onChangeCategory(value);
            },
          ),

          CustomInput(
            labelText: 'Descripción',
            value: widget.product?.description ?? '',
            borderColor: AppColors.grisBorder,
            validationType: InputValidationType.required,
            onChanged: (value, _) {
              cubit.onChangeDescription(value);
            },
          ),

          CustomInput(
            labelText: 'Precio',
            value: (widget.product?.price ?? '').toString(),
            borderColor: AppColors.grisBorder,
            validationType: InputValidationType.required,
            keyboardType: TextInputType.number,
            onChanged: (value, _) {
              cubit.onChangePrice(value);
            },
          ),

          CustomInput(
            labelText: 'Precio descuento ( Nuevo Precio )',
            value: (widget.product?.discountPrice ?? '').toString(),
            borderColor: AppColors.grisBorder,
            validationType: InputValidationType.required,
            keyboardType: TextInputType.number,
            onChanged: (value, _) {
              cubit.onChangeDiscountPrice(value);
            },
          ),

          SizedBox(),

          CustomButton(
            value: textButton,
            width: MediaQuery.of(context).size.width,
            onTap: () async {
              if (widget.product != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return CustomDialog(
                      title: 'Editar producto',
                      subContent: '¿Está seguro de editar este producto?',
                      onAccept: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const DialogLoading(),
                        );

                        final value = await cubit.addProduct(
                          isProduct: widget.product != null,
                          productId: widget.product?.id ?? '',
                          image: photo?.file,
                        );

                        if (value.isEmpty) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AppLayout();
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
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const DialogLoading(),
                );

                final value = await cubit.addProduct(
                  isProduct: widget.product != null,
                  productId: widget.product?.id ?? '',
                  image: photo?.file,
                );

                if (value.isEmpty) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return AppLayout();
                      },
                    ),
                    (_) => false,
                  );
                } else {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);

                    await SnackBarUtils.snackBarGeneric(context, value: value);
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
