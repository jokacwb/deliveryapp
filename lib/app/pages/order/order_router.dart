import 'package:dw9_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw9_delivery_app/app/pages/order/order_page.dart';
import 'package:dw9_delivery_app/app/repository/order/order_repository.dart';
import 'package:dw9_delivery_app/app/repository/order/order_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderRouter {
  OrderRouter._();
  static const String routeName = '/order';
  static Widget get page => MultiProvider(
        providers: [
          Provider<OrderRepository>(create: (context) => OrderRepositoryImpl(dio: context.read())),
          Provider(create: (context) => OrderController(context.read())),
        ],
        child: const OrderPage(),
      );

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
