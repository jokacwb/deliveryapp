import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Page'),
      ),
      body: Column(
        children: [
          Container(),
          DeliveryButton(
            label: 'Coloque o dedo aqui',
            onPressed: () {},
            width: MediaQuery.of(context).size.width * .8,
          ),
          TextFormField(),
        ],
      ),
    );
  }
}
