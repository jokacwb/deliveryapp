import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/pages/home/home_state.dart';
import 'package:dw9_delivery_app/app/repository/products/products_repository.dart';

class HomeController extends Cubit<HomeState> {
  final ProductsRepository _productsRepository;

  HomeController(this._productsRepository) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      final products = await _productsRepository.findAllProducts();
      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } on Exception catch (e, s) {
      log('Erro ao buscar lista de produto', error: e, stackTrace: s);
      emit(
        state.copyWith(status: HomeStateStatus.error, errorMessage: 'Erro ao buscar produto'),
      );
    }
  }

  void addOrUpdateBag(OrderProductDto orderProductDto) {
    //Eh feito com ...  para forçar a destruição e recriação de uma nova lista e o flutter entenda que houve alteração de estado
    final shoppingBag = [...state.shoppingBag];
    final orderIndex = shoppingBag.indexWhere((op) => op.product == orderProductDto.product);
    if (orderIndex > -1) {
      if (orderProductDto.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProductDto;
      }
    } else {
      shoppingBag.add(orderProductDto);
    }
    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
