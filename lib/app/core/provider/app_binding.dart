import 'package:dw9_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBinding extends StatelessWidget {
  final Widget child;

  const AppBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => CustomDio(),
        )
      ],
      child: child,
    );
  }
}
