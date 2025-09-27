// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/texts_style.dart';
import 'custom_image_cache.dart';
import 'input_validation_type.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({
    super.key,
    this.controller,
    this.focusNode,
    this.value,
    this.hintText = '',
    this.labelText,
    this.onChanged,
    this.onCompleted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.autoUnfocusOnBuild = false,
    this.borderColor,
    this.borderRadius = 7.0,
    this.prefixDynamic,
    this.suffixDynamic,
    this.suffixOnTap,
    this.iconSize = 18,
    this.iconColor,
    this.horizontalPadding = 10.0,
    this.verticalPadding = 12.0,
    this.hintStyle,
    this.style,
    this.labelStyle,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.showCounter = false,
    this.onTap,
    this.allowWhiteSpace = true,
    this.textAlign,
    this.validationType = InputValidationType.none,
    this.minLength,
    this.isBorder = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? value;
  final String hintText;
  final String? labelText;
  final Function(String, bool)? onChanged;
  final VoidCallback? onCompleted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool autoUnfocusOnBuild;
  final Color? borderColor;
  final double borderRadius;
  final dynamic prefixDynamic;
  final dynamic suffixDynamic;
  final VoidCallback? suffixOnTap;
  final double iconSize;
  final Color? iconColor;
  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final bool showCounter;
  final VoidCallback? onTap;
  final bool allowWhiteSpace;
  final TextAlign? textAlign;
  final InputValidationType validationType;
  final int? minLength;
  final bool isBorder;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late final TextEditingController _internalController;
  bool _isInternalController = false;
  bool _isObscured = false;
  late final FocusNode _effectiveFocusNode;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _isObscured = widget.obscureText;

    final cleanValue =
        widget.allowWhiteSpace
            ? widget.value ?? ''
            : (widget.value ?? '').replaceAll(' ', '');

    if (widget.controller != null) {
      _internalController = widget.controller!;
    } else {
      _internalController = TextEditingController(text: cleanValue);
      _isInternalController = true;
    }
  }

  @override
  void didUpdateWidget(covariant CustomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInternalController) {
      final updatedValue =
          widget.allowWhiteSpace
              ? widget.value ?? ''
              : (widget.value ?? '').replaceAll(' ', '');

      if (widget.value != oldWidget.value &&
          updatedValue != _internalController.text) {
        _internalController.text = updatedValue;
      }
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _internalController.dispose();
    }
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextsStyle(context);

    if (widget.autoUnfocusOnBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });
    }

    final defaultIconColor =
        widget.iconColor ?? Theme.of(context).textTheme.bodyMedium?.color;

    OutlineInputBorder _border(Color? color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color ?? Colors.transparent),
    );

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _internalController,
      focusNode: _effectiveFocusNode,
      onChanged: (str) {
        final value = str.trimRight();

        final isValid = widget.validationType.validate(
          value,
          minLength: widget.minLength,
        );
        widget.onChanged?.call(value, isValid == null);
      },
      validator:
          (value) => widget.validationType.validate(
            value ?? '',
            minLength: widget.minLength,
          ),
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly || widget.onTap != null,
      enabled: widget.enabled,
      style: widget.style ?? textStyle.bodyMedium,
      onFieldSubmitted: (_) => widget.onCompleted?.call(),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autofocus,
      textCapitalization: textCapitalization,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      inputFormatters: [
        if (widget.inputFormatters != null) ...widget.inputFormatters!,
        if (!widget.allowWhiteSpace)
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      textAlign: widget.textAlign ?? TextAlign.left,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: widget.labelStyle ?? textStyle.hint,
        hintStyle: widget.hintStyle ?? textStyle.hint,
        prefixIcon: _buildDynamicIcon(widget.prefixDynamic, defaultIconColor),
        border:
            widget.isBorder ? InputBorder.none : _border(widget.borderColor),
        focusedBorder:
            widget.isBorder ? InputBorder.none : _border(Colors.blue),
        enabledBorder:
            widget.isBorder ? InputBorder.none : _border(widget.borderColor),
        disabledBorder:
            widget.isBorder ? InputBorder.none : _border(widget.borderColor),
        errorBorder: widget.isBorder ? InputBorder.none : _border(Colors.red),
        focusedErrorBorder:
            widget.isBorder ? InputBorder.none : _border(Colors.red),
        isDense: !widget.isBorder,
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    size: widget.iconSize,
                    color:
                        widget.iconColor ?? Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
                : widget.suffixDynamic != null
                ? GestureDetector(
                  onTap: widget.suffixOnTap,
                  child: _buildDynamicIcon(
                    widget.suffixDynamic,
                    defaultIconColor,
                  ),
                )
                : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding,
        ),
        counterText: widget.showCounter ? null : '',
      ),
    );
  }

  TextCapitalization get textCapitalization {
    if (widget.keyboardType == TextInputType.name) {
      return TextCapitalization.words;
    } else if (widget.keyboardType == TextInputType.text) {
      return TextCapitalization.sentences;
    } else if (widget.obscureText) {
      return TextCapitalization.none;
    } else {
      return widget.textCapitalization;
    }
  }

  Widget? _buildDynamicIcon(dynamic data, Color? color) {
    if (data == null) return null;
    if (data is IconData) {
      return Icon(data, size: widget.iconSize, color: color);
    } else if (data is String) {
      return SizedBox(
        width: 30,
        child: Center(
          child: CustomImageCache(
            url: data,
            height: widget.iconSize,
            width: widget.iconSize,
            fit: BoxFit.scaleDown,
            imageColor: color,
          ),
        ),
      );
    }
    return null;
  }
}
