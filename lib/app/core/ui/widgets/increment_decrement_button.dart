import 'package:dw9_delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';

class IncrementDecrementButton extends StatelessWidget {
  final int amount;
  final VoidCallback onIncrementTap;
  final VoidCallback onDecrementTap;

  const IncrementDecrementButton({
    super.key,
    required this.amount,
    required this.onIncrementTap,
    required this.onDecrementTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: onDecrementTap,
              child: const Icon(
                Icons.remove_circle_outlined,
                color: Colors.red,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              amount.toString(),
              style: context.textStyles.textRegular.copyWith(fontSize: 18, color: context.colors.secondary, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: onIncrementTap,
            child: const Icon(
              Icons.add_circle_outlined,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
