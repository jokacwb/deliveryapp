import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:dw9_delivery_app/app/models/product_model.dart';
import 'package:dw9_delivery_app/app/pages/home/widgets/product_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ProductTile(
                  product: ProductModel(
                id: 1,
                name: 'Pensadao 2 vinas',
                description: 'Pão com duas vinas, batata panha, queijo e muito sal e pimenta dedo de moça',
                price: 22.99,
                image: 'https://kahdog.com.br/wp-content/uploads/2021/07/Fotos-Site-Kahdog6-300x300.jpg',
              ));
            },
          ),
        )
      ]),
    );
  }
}
