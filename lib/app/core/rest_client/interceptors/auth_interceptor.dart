import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw9_delivery_app/app/core/global/global_context.dart';
import 'package:dw9_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../exceptions/expire_token_exception.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;
  static const _rotaRefresh = '/auth/refresh';
  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString('accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        //Se a chamada não for o propria chamada do refreshtoken aciona o processo re refresh
        if (err.requestOptions.path != _rotaRefresh) {
          //Tenta refazer o login via refresh token
          await _refresheToken(err);
          //Se conseguiu refazer o login tenta refazer a requisição original
          await _retryRequest(err, handler);
        } else {
          //Se der erro 401 na chamada do processo de refresh ai desiste e devolve usuário para pagina inicial (neste caso especifico a home publica que é o cardapio)
          GlobalContext.i.loginExprired();
        }
      } catch (e) {
        //se der qualquer erro no processo de refreah tambem  desiste e devolve usuário para pagina inicial (neste caso especifico a home publica que é o cardapio)
        GlobalContext.i.loginExprired();
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refresheToken(DioError err) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final refreshToken = sp.getString('refreshToken');
      if (refreshToken == null) {
        return;
      }
      final result = await dio.auth().put(
        _rotaRefresh,
        data: {'refresh_token': refreshToken},
      );
      sp.setString('accessToken', result.data['access_token']);
      sp.setString('refreshToken', result.data['refresh_token']);
    } on DioError catch (e, s) {
      log('Erro ao tentar realizar refresh token', error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }

  Future<void> _retryRequest(DioError err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final result = await dio.request(requestOptions.path,
        options: Options(
          headers: requestOptions.headers,
          method: requestOptions.method,
        ),
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters);
    handler.resolve(
      Response(requestOptions: requestOptions, data: result.data, statusCode: result.statusCode, statusMessage: result.statusMessage),
    );
  }
}
