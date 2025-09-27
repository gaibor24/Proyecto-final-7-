import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../themes/texts_style.dart';
import 'custom_card.dart';

class QuantityCounter extends StatefulWidget {
  const QuantityCounter({
    super.key,
    this.min = 1,
    required this.max,
    this.initialValue,
    required this.onChanged,
    this.sizeButton = 50,
    this.sizeWidth = 80,
  });

  final int min;
  final int max;
  final int? initialValue;
  final double sizeButton;
  final double sizeWidth;

  final Function(int value, String? errorMessage) onChanged;

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int _value;
  String? _limitMessage;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.min;
  }

  void _increment() {
    if (_value < widget.max) {
      setState(() {
        _value++;
        _limitMessage = null;
      });
      widget.onChanged(_value, null);
    } else {
      setState(() {
        _limitMessage = "Cantidad máxima alcanzada";
      });
      widget.onChanged(_value, _limitMessage);
    }
  }

  void _decrement() {
    if (_value > widget.min) {
      setState(() {
        _value--;
        _limitMessage = null;
      });
      widget.onChanged(_value, null);
    } else {
      setState(() {
        _limitMessage = "Cantidad mínima alcanzada";
      });
      widget.onChanged(_value, _limitMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              width: widget.sizeButton,
              height: widget.sizeButton,
              border: Border.all(color: AppColors.grisBorder),
              onTap: _decrement,
              child: Center(child: const Icon(Icons.remove)),
            ),
            SizedBox(
              width: widget.sizeWidth,
              height: widget.sizeButton,
              child: Center(
                child: Text(
                  '$_value',
                  style: TextsStyle(context).titleMedium.copyWith(fontSize: 16),
                ),
              ),
            ),
            CustomCard(
              width: widget.sizeButton,
              height: widget.sizeButton,
              backgroundColor: Colors.black,
              onTap: _increment,
              child: Center(child: const Icon(Icons.add, color: Colors.white)),
            ),
          ],
        ),
        if (_limitMessage != null)
          Text(
            _limitMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
      ],
    );
  }
}
