import 'dart:developer';

import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/dto/order_dto.dart';
import 'package:dw9_delivery_app/app/pages/order/order_state.dart';
import 'package:dw9_delivery_app/app/repository/order/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderController(this._orderRepository) : super(const OrderState.initial());

  void load(List<OrderProductDto> listProducts) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));
      final paymentsTypes = await _orderRepository.listAllPaymentsTypes();

      emit(
        state.copyWith(
          orderProducts: listProducts,
          status: OrderStatus.loaded,
          paymentsTypes: paymentsTypes,
        ),
      );
    } catch (e, s) {
      log('Erro ao tentar obter formas de pagamwnto', error: e, stackTrace: s);
      emit(state.copyWith(status: OrderStatus.error, errorMessage: 'Erro ao carrega página'));
    }
  }

  void incrementProduct(int index) {
    //Pedidos , esta sendo usado os ... que indica a geração de uma nova lista com os pedidos, assim
    //o bloc entende que houve alteração na lista e efetua os processos de atualização de estado.
    final orders = [...state.orderProducts];
    final order = orders[index];
    orders[index] = order.copyWith(amount: order.amount + 1);
    emit(state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    //Pedidos , esta sendo usado os ... que indica a geração de uma nova lista com os pedidos, assim
    //o bloc entende que houve alteração na lista e efetua os processos de atualização de estado.
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;
    if (amount == 1) {
      if (state.status != OrderStatus.confirmDeleteProduct) {
        emit(
          OrderConfirmDeleteProductState(
            orderProductDto: order,
            index: index,
            status: OrderStatus.confirmDeleteProduct,
            orderProducts: state.orderProducts,
            paymentsTypes: state.paymentsTypes,
            errorMessage: state.errorMessage,
          ),
        );
        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }
    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    }
    emit(state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void cancelDelete() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void esvaziarSacola() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder({required String address, required String document, required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepository.saveOrder(
      OrderDto(
        produtos: state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId,
      ),
    );
    emit(state.copyWith(status: OrderStatus.success));
  }
}
