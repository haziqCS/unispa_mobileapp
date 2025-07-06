import 'package:flutter/material.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/utils/config.dart';
import 'package:unispa_mobileapp/utils/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outlined),
              prefixIconColor: Config.primaryColor,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: obsecurePass
                    ? const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black38,
                      )
                    : const Icon(
                        Icons.visibility_outlined,
                        color: Config.primaryColor,
                      ),
              ),
            ),
          ),
          Config.spaceSmall,
          //Login Button
          Button(
            width: double.infinity,
            title: 'Sign In',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final email = _emailController.text.trim();
                final password = _passController.text;

                // Simple check: if admin username + hardcoded password for example
                if (email == 'admin' && password == 'admin123') {
                  Config.showSnack(context, 'Admin login successful!');
                  Navigator.of(context).pushReplacementNamed('admin_homepage');
                  return; // skip normal flow
                }

                print('📡 Calling AuthService.login...');
                final authService = AuthService();
                final result = await authService.login(email, password);
                print('✅ AuthService.login returned: $result');

                if (result['success']) {
                  if (!mounted) return;
                  Config.showSnack(context, 'Login successful!');
                  Navigator.of(context).pushReplacementNamed('main');
                } else {
                  if (!mounted) return;
                  Config.showSnack(
                    context,
                    result['message'] ?? 'Login failed',
                  );
                }
              }
            },
            disable: false,
          ),
        ],
      ),
    );
  }
}
