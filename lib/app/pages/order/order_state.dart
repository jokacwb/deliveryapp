// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/models/payment_type_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  updateOrder,
  confirmDeleteProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;

  //Produtos do pedido
  final List<OrderProductDto> orderProducts;
  //Formas de pagamento
  final List<PaymentTypeModel> paymentsTypes;
  //Msg de erro
  final String? errorMessage;

  const OrderState({required this.status, required this.orderProducts, required this.paymentsTypes, this.errorMessage});

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProducts = const [],
        errorMessage = null,
        paymentsTypes = const [];

  double get totalOrder => orderProducts.fold(0.0, (previousValue, element) => previousValue + element.totalPrice);

  @override
  List<Object?> get props => [status, orderProducts, paymentsTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProducts,
    List<PaymentTypeModel>? paymentsTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentsTypes: paymentsTypes ?? this.paymentsTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProductDto;
  final int index;

  const OrderConfirmDeleteProductState({required this.orderProductDto, required this.index, required super.status, required super.orderProducts, required super.paymentsTypes, super.errorMessage});
}
