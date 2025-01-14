import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../common/validators.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_textfield.dart';
import '../../../features/home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isValidated = false;

  @override
  void initState() {
    email.addListener(() {
      final text = email.text;
      if (text.contains(' ')) {
        email.value = email.value.copyWith(
          text: text.replaceAll(' ', ''),
          selection:
              TextSelection.collapsed(offset: text.replaceAll(' ', '').length),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  header(),
                  const SizedBox(height: 32),
                  body(),
                  if (isValidated) incorrectCredentials(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return const Text(
      'Welcome Back!',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
    );
  }

  Widget incorrectCredentials() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Incorrect email or password',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget body() {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          hintText: 'Email',
          controller: email,
          icon: Icons.email,
          validator: (value) => Validators.emailValidate(value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          isObscure: true,
          trailing: const Icon(Icons.visibility_off),
          hintText: 'Password',
          controller: password,
          icon: Icons.lock,
          validator: (value) => Validators.passwordValidate(value),
        ),
        const SizedBox(height: 24),
        if (authProvider.isLoading)
          const CircularProgressIndicator()
        else
          CustomButton(
            label: 'LOGIN',
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                setState(() => isValidated = false);
                final success = await authProvider.login(
                  email.text,
                  password.text,
                );
                if (success) {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Home(title: 'Library Manager'),
                      ),
                    );
                  }
                } else {
                  setState(() => isValidated = true);
                }
              }
            },
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Implement forgot password
              },
              child: const Text('Forgot Password?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ],
    );
  }
}
