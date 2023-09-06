import 'package:amazon_clone/app/common/widgets/custom_button.dart';
import 'package:amazon_clone/app/constants/global_variables.dart';
import 'package:amazon_clone/app/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/custom_text_field.dart';

enum Auth {
  sigin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Bem Vindo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              tileColor: _auth == Auth.signup
                  ? GlobalVariables.backgroundColor
                  : GlobalVariables.greyBackgroundColor,
              title: const Text(
                'Criar Conta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                activeColor: GlobalVariables.secondaryColor,
                value: Auth.signup,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),
            if (_auth == Auth.signup)
              Container(
                padding: const EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _nameController, hintText: 'Nome'),
                      const SizedBox(height: 8),
                      CustomTextField(
                          controller: _emailController, hintText: 'E-mail'),
                      const SizedBox(height: 8),
                      CustomTextField(
                          controller: _passwordController, hintText: 'Senha'),
                      const SizedBox(height: 8),
                      CustomButton(
                          text: "Criar Conta",
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              authService.createAccount(
                                  context: context,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          }),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ListTile(
              title: const Text(
                'Entrar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Radio(
                activeColor: GlobalVariables.secondaryColor,
                value: Auth.sigin,
                groupValue: _auth,
                onChanged: (Auth? value) {
                  setState(() {
                    _auth = value!;
                  });
                },
              ),
            ),
            if (_auth == Auth.sigin)
              Container(
                padding: const EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _emailController, hintText: 'E-mail'),
                      const SizedBox(height: 8),
                      CustomTextField(
                          controller: _passwordController, hintText: 'Senha'),
                      const SizedBox(height: 8),
                      CustomButton(
                          text: "Entrar",
                          onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              authService.login(
                                  context: context,
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
          ],
        ),
      )),
    );
  }
}
