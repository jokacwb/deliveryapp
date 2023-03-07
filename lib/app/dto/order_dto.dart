// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';

class OrderDto {
  List<OrderProductDto> produtos;
  String address; //Endereço
  String document; //CPF
  int paymentMethodId; //ID da Forma de pagamento

  OrderDto({
    required this.produtos,
    required this.address,
    required this.document,
    required this.paymentMethodId,
  });
}
