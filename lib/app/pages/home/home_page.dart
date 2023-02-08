import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/appbar_custom.dart';
import 'package:dw9_delivery_app/app/pages/home/home_controller.dart';
import 'package:dw9_delivery_app/app/pages/home/home_state.dart';
import 'package:dw9_delivery_app/app/pages/home/widgets/product_tile.dart';
import 'package:dw9_delivery_app/app/pages/home/widgets/shopping_bag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() {
    //Busca os produtos depois que a tela de home for construida
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(),
      body: BlocConsumer<HomeController, HomeState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            loading: () => showLoader(),
            error: () {
              hideLoader();
              showError(state.errorMessage ?? ' Erro não informado!');
            },
          );
        },
        buildWhen: (previous, current) => current.status.matchAny(
          any: () => false,
          initial: () => true,
          loaded: () => true,
        ),
        builder: (context, state) {
          return Column(children: [
            Text(state.shoppingBag.length.toString()),
            Expanded(
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  final orders = state.shoppingBag.where(
                    (order) => order.product == product,
                  );
                  return ProductTile(
                    product: product,
                    orderProductDto: orders.isNotEmpty ? orders.first : null,
                  );
                },
              ),
            ),
            Visibility(
              visible: state.shoppingBag.isNotEmpty,
              child: ShoppingBag(
                bag: state.shoppingBag,
              ),
            )
          ]);
        },
      ),
    );
  }
}
