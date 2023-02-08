import 'package:dw9_delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class IncrementDecrementButton extends StatelessWidget {
  final int amount;
  final VoidCallback onIncrementTap;
  final VoidCallback onDecrementTap;
  final bool _compact;

  const IncrementDecrementButton({
    super.key,
    required this.amount,
    required this.onIncrementTap,
    required this.onDecrementTap,
  }) : _compact = false;

  const IncrementDecrementButton.compact({
    super.key,
    required this.amount,
    required this.onIncrementTap,
    required this.onDecrementTap,
  }) : _compact = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: _compact ? const EdgeInsets.all(8) : const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: onDecrementTap,
              child: Icon(
                Icons.remove_circle_outlined,
                color: Colors.red,
                size: _compact ? 20 : 30,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              amount.toString(),
              style: context.textStyles.textRegular.copyWith(
                fontSize: _compact ? 16 : 18,
                color: context.colors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: onIncrementTap,
            child: Icon(
              Icons.add_circle_outlined,
              color: Colors.green,
              size: _compact ? 20 : 30,
            ),
          ),
        ],
      ),
    );
  }
}
