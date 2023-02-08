import 'package:dw9_delivery_app/app/pages/order/order_page.dart';
import 'package:flutter/material.dart';

class OrderRouter {
  OrderRouter._();
  static const String routeName = '/order';
  static Widget get page => const OrderPage();

/*
  static Widget get page => MultiProvider(
        providers: [
          Provider<ProductsRepository>(
            create: (context) => ProductsRepositoryImpl(dio: context.read()),
          ),
          Provider(
            create: (context) => HomeController(context.read()),
          )
        ],
        child: const HomePage(),
      );
      */
}
