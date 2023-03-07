import 'package:dw9_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw9_delivery_app/app/pages/order/order_completed_router.dart';
import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/appbar_custom.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/button_custom.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/models/payment_type_model.dart';
import 'package:dw9_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw9_delivery_app/app/pages/order/order_state.dart';
import 'package:dw9_delivery_app/app/pages/order/widget/order_field.dart';
import 'package:dw9_delivery_app/app/pages/order/widget/order_product_tile.dart';
import 'package:dw9_delivery_app/app/pages/order/widget/payment_types_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final enderecoEC = TextEditingController();
  final cpfEC = TextEditingController();
  int? paymentTypeId; //Id da forma de pagamento
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final listProducts = ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(listProducts);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Deseja excluir o produto ${state.orderProductDto.product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDelete();
              },
              child: Text(
                'Não',
                style: context.textStyles.textExtraBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.decrementProduct(state.index);
              },
              child: Text(
                'Sim',
                style: context.textStyles.textExtraBold,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () {
              hideLoader();
            },
            loading: () => showLoader(),
            loaded: () => hideLoader(),
            error: () {
              hideLoader();
              showError(state.errorMessage ?? 'Erro inesperado!');
            },
            confirmDeleteProduct: () {
              hideLoader();
              if (state is OrderConfirmDeleteProductState) {
                _showConfirmProductDialog(state);
              }
            },
            emptyBag: () {
              showInfo('Lista de pedidos vazia.');
              //Volta para lista de produtos (menu) e com lista de pedidos vazia
              Navigator.pop(context, <OrderProductDto>[]);
            },
            success: () {
              hideLoader();
              Navigator.of(context).popAndPushNamed(OrderCompletedRouter.routeName, result: <OrderProductDto>[]);
            });
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false; // Este false anula o botão voltar do celular ( a volta ocorre no comando acima, para podermos mandar o sacola de pedidos)
        },
        child: Scaffold(
          appBar: AppbarCustom(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          'Sacola',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.esvaziarSacola();
                            },
                            icon: Image.asset('assets/images/trashRegular.png'))
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState, List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, listProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: listProducts.length,
                        (context, index) {
                          final orderProduct = listProducts[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProductDto: orderProduct,
                              ),
                              const Divider(
                                color: Colors.grey,
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold.copyWith(fontSize: 16),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style: context.textStyles.textExtraBold.copyWith(fontSize: 20),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: enderecoEC,
                        validator: Validatorless.required('Informe o endereço'),
                        hintText: 'Digite o endereço de entrega',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: cpfEC,
                        validator: Validatorless.required('Infome um CPF valido'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocSelector<OrderController, OrderState, List<PaymentTypeModel>>(
                        selector: (state) => state.paymentsTypes,
                        builder: (context, paymentsTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentsTypes: paymentsTypes,
                                valueChanged: (idFP) {
                                  paymentTypeId = idFP;
                                },
                                isValid: paymentTypeValidValue,
                                fpSelecionada: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ButtonCustom(
                          width: double.infinity,
                          height: 48,
                          label: 'FINALIZAR',
                          onPressed: () {
                            final isValid = formKey.currentState?.validate() ?? false;
                            final isFpSelecionada = paymentTypeId != null;
                            paymentTypeValid.value = isFpSelecionada;
                            if (isValid && isFpSelecionada) {
                              controller.saveOrder(
                                address: enderecoEC.text,
                                document: cpfEC.text,
                                paymentMethodId: paymentTypeId!,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
