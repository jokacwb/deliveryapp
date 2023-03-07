import 'package:dw9_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/button_custom.dart';
import 'package:dw9_delivery_app/app/pages/auth/login/login_controller.dart';
import 'package:dw9_delivery_app/app/pages/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/appbar_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginController, LoginState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          login: () => showLoader(),
          loginError: () {
            hideLoader();
            showError('${state.errorMessage}');
          },
          error: () {
            hideLoader();
            showError('Falha no login: ${state.errorMessage}');
          },
          success: () {
            hideLoader();
            //Passa true no segundo parametro indicando que login foi feito com sucesso
            Navigator.pop(context, true);
          },
        );
      },
      child: Scaffold(
        appBar: AppbarCustom(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: context.textStyles.textTitle,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        controller: _emailEC,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validatorless.multiple([Validatorless.required('Informe o E-mail.'), Validatorless.email('Email não está com formato válido!')]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Senha'),
                        controller: _passwordEC,
                        obscureText: true,
                        validator: Validatorless.required('Senha deve ser informada.'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: ButtonCustom(
                          label: 'ENTRAR',
                          onPressed: () {
                            final valid = _formKey.currentState?.validate() ?? false;
                            if (valid) {
                              controller.login(_emailEC.text, _passwordEC.text);
                            }
                          },
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      'Não possui conta',
                      style: context.textStyles.textBold,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/auth/register');
                      },
                      child: Text(
                        'Cadastre-se',
                        style: context.textStyles.textBold.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
