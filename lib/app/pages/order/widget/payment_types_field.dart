import 'dart:developer';

import 'package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/models/payment_type_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';

class PaymentTypesField extends StatelessWidget {
  final List<PaymentTypeModel> paymentsTypes;
  final ValueChanged<int> valueChanged;
  final bool isValid;
  final String fpSelecionada;

  const PaymentTypesField({
    super.key,
    required this.paymentsTypes,
    required this.valueChanged,
    required this.isValid,
    required this.fpSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forma de pagamento',
            style: context.textStyles.textRegular.copyWith(fontSize: 16),
          ),
          SmartSelect<String>.single(
            title: '',
            selectedValue: fpSelecionada,
            modalType: S2ModalType.bottomSheet,
            onChange: (itemSelecionado) {
              log(itemSelecionado.toString());
              valueChanged(int.parse(itemSelecionado.value));
            },
            tileBuilder: (context, state) {
              return InkWell(
                onTap: state.showModal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: context.screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.selected.title ?? 'não selecionado',
                            style: context.textStyles.textRegular,
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded)
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !isValid,
                      child: const Divider(
                        color: Colors.red,
                      ),
                    ),
                    Visibility(
                      visible: !isValid,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Selecione uma forma de pagamento',
                          style: context.textStyles.textRegular.copyWith(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            choiceItems: S2Choice.listFrom<String, Map<String, String>>(
              source: paymentsTypes.map((fp) => {'value': fp.id.toString(), 'title': fp.name}).toList(),
              //Exemplo de lista fixa (sem backend)
              // [
              //   {'value': 'VA', 'title': 'Vale Alimentação'},
              //   {'value': 'VR', 'title': 'Vale Refeição'},
              //   {'value': 'CC', 'title': 'Cartão de Crédito'},
              // ],
              title: (index, item) => item['title'] ?? '',
              value: (index, item) => item['value'] ?? '',
              group: (index, item) => 'Selecione uma forma de pagamento',
            ),
            choiceType: S2ChoiceType.radios,
            choiceGrouped: true,
            modalFilter: false,
            placeholder: '',
          )
        ],
      ),
    );
  }
}
