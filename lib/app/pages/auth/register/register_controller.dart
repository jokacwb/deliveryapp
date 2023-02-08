import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_state.dart';
import 'package:dw9_delivery_app/app/repository/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterController extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterController(this._repository) : super(const RegisterState.initial());

  Future<void> register(String name, String email, String password) async {
    try {
      emit(state.copyWith(status: RegisterStatus.register));
      await _repository.register(name, email, password);
      emit(state.copyWith(status: RegisterStatus.success));
    } on DioError catch (e, s) {
      log('Erro ao cadastrar usuario', error: e, stackTrace: s);
      emit(state.copyWith(status: RegisterStatus.error));
    }
  }
}
