import 'package:dw9_delivery_app/app/pages/auth/login/login_router.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_router.dart';
import 'package:dw9_delivery_app/app/pages/home/home_router.dart';
import 'package:dw9_delivery_app/app/pages/order/order_completed_page.dart';
import 'package:dw9_delivery_app/app/pages/order/order_completed_router.dart';
import 'package:dw9_delivery_app/app/pages/order/order_router.dart';
import 'package:dw9_delivery_app/app/pages/product_detail/product_detail_router.dart';

import '/app/core/provider/app_binding.dart';
import '/app/core/ui/theme/theme_config.dart';
import '/app/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'core/global/global_context.dart';

class Dw9DeliveryApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  Dw9DeliveryApp({super.key}) {
    GlobalContext.i.navigatorKey = _navKey;
  }

  @override
  Widget build(BuildContext context) {
    return AppBinding(
      child: MaterialApp(
        theme: ThemeConfig.theme,
        debugShowCheckedModeBanner: false,
        title: 'Delivery App',
        navigatorKey: _navKey,
        routes: {
          '/': (context) => const SplashPage(),
          HomeRouter.routeName: (context) => HomeRouter.page,
          ProductDetailRouter.routeName: (context) => ProductDetailRouter.page,
          LoginRouter.routeName: (context) => LoginRouter.page,
          RegisterRouter.routeName: (context) => RegisterRouter.page,
          OrderRouter.routeName: (context) => OrderRouter.page,
          OrderCompletedRouter.routeName: (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
