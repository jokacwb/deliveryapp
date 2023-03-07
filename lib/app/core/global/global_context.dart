import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../pages/home/home_router.dart';

class GlobalContext {
  //! ATENCAO nunca deixar o navigatorKey publico!!
  late final GlobalKey<NavigatorState> _navigatorKey;

  static GlobalContext? _instance;

  GlobalContext._();
  static GlobalContext get i {
    _instance ??= GlobalContext._();
    return _instance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  Future<void> loginExprired() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    showTopSnackBar(
      _navigatorKey.currentState!.overlay!,
      const CustomSnackBar.error(
        message: 'Login expirado! Clique na sacola novamente.',
        backgroundColor: Colors.black,
      ),
    );

    //fecha as telas até chegar a tela inicial (neste caso a home com o cardapio)
    _navigatorKey.currentState!.popUntil(ModalRoute.withName(HomeRouter.routeName));
  }
}
