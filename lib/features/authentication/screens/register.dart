import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../common/validators.dart';
import '../../../common/requirements_box.dart';
import 'widgets/background.dart';
import 'login.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_textfield.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showPasswordRequirements = false;
  FocusNode passwordFocus = FocusNode();
  final GlobalKey passwordKey = GlobalKey();
  Offset? textFieldPosition;

  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
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

    passwordFocus.addListener(() {
      if (passwordFocus.hasFocus) {
        getTextFieldPosition();
        setState(() {
          showPasswordRequirements = true;
        });
      } else {
        setState(() {
          showPasswordRequirements = false;
        });
      }
    });

    password.addListener(() {
      if (password.text.isNotEmpty) {
        setState(() {
          showPasswordRequirements = true;
        });
      }
      if (!passwordFocus.hasFocus) {
        setState(() {
          showPasswordRequirements = false;
        });
      }
    });
    super.initState();
  }

  void getTextFieldPosition() {
    final RenderBox renderBox =
        passwordKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      textFieldPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(
          height: 0.7,
          image: 'register.png',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  header(),
                  body(),
                  if (isValidated) incorrectCredentials(),
                ],
              ),
            ),
          ),
        ),
        if (showPasswordRequirements && textFieldPosition != null)
          Positioned(
            top: textFieldPosition!.dy + 20,
            left: textFieldPosition!.dx + 350,
            child: PasswordRequirementBox(password: password.text),
          ),
      ],
    );
  }

  Widget header() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        'Create Account',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget incorrectCredentials() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        'Registration failed. Please try again.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget body() {
    final authProvider = Provider.of<AuthProvider>(context);

    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Email',
                controller: email,
                icon: Icons.email,
                validator: (value) => Validators.emailValidate(value),
              ),
              CustomTextField(
                isObscure: true,
                key: passwordKey,
                focusNode: passwordFocus,
                trailing: const Icon(Icons.visibility_off),
                hintText: 'Password',
                controller: password,
                icon: Icons.lock,
                validator: (value) => Validators.passwordValidate(value),
              ),
              CustomTextField(
                isObscure: true,
                trailing: const Icon(Icons.visibility_off),
                hintText: 'Confirm Password',
                controller: confirmPassword,
                icon: Icons.lock,
                validator: (value) =>
                    Validators.confirmPasswordValidate(value, password.text),
              ),
              if (authProvider.isLoading)
                const CircularProgressIndicator()
              else
                CustomButton(
                  label: 'Register',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isValidated = false);
                      final success = await authProvider.register(
                        email.text,
                        password.text,
                      );
                      if (success) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        }
                      } else {
                        setState(() => isValidated = true);
                      }
                    }
                  },
                ),
              haveAnAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget haveAnAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
