import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/appbar_custom.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/button_custom.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_controller.dart';
import 'package:dw9_delivery_app/app/pages/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          register: () => showLoader(),
          error: () {
            hideLoader();
            showError('Falha ao cadastrar usuário');
          },
          success: () {
            hideLoader();
            showSuccess('Usuário cadastrado com sucesso');
            Navigator.pop(context);
          },
        );
      },
      child: Scaffold(
        appBar: AppbarCustom(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cadastro',
                      style: context.textStyles.textTitle,
                    ),
                    Text(
                      'Preencha os campos para criar seu cadastro',
                      style: context.textStyles.textMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      controller: _nameEC,
                      validator: Validatorless.required('Por favor informe o seu nome completo'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        controller: _emailEC,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validatorless.multiple(
                          [Validatorless.required('Informe o E-mail'), Validatorless.email('Formato do Email incorreto.')],
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                      controller: _passwordEC,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Informe a senha'),
                          Validatorless.min(6, 'Informe ao menos 6 digitos para senha'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Confirma Senha'),
                      obscureText: true,
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('Informe a confirmação de senha'),
                          Validatorless.compare(_passwordEC, 'Senha e confirmação de senha devem ser iguais'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ButtonCustom(
                        label: 'Cadastrar',
                        width: double.infinity,
                        onPressed: () {
                          final valid = _formKey.currentState?.validate() ?? false;
                          if (valid) {
                            controller.register(_nameEC.text, _emailEC.text, _passwordEC.text);
                          }
                        },
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
