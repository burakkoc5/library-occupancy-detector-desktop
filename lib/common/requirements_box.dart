import 'package:flutter/material.dart';

class PasswordRequirementBox extends StatefulWidget {
  final String password;

  const PasswordRequirementBox({super.key, required this.password});

  @override
  State<PasswordRequirementBox> createState() => _PasswordRequirementBoxState();
}

class _PasswordRequirementBoxState extends State<PasswordRequirementBox> {
  bool containsUppercase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  bool containsLowercase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  bool containsNumber(String password) => password.contains(RegExp(r'\d'));

  bool containsSpecialChar(String password) =>
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  bool isLongEnough(String password) => password.length >= 8;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.25,
      child: Card(
        margin: const EdgeInsets.only(top: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequirement(
                'En az bir büyük harf',
                containsUppercase(widget.password),
              ),
              _buildRequirement(
                'En az bir küçük harf',
                containsLowercase(widget.password),
              ),
              _buildRequirement(
                'En az bir rakam',
                containsNumber(widget.password),
              ),
              _buildRequirement(
                'En az bir özel karakter (!@#\$%^&*)',
                containsSpecialChar(widget.password),
              ),
              _buildRequirement(
                'En az 8 karakter uzunluğunda',
                isLongEnough(widget.password),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isSatisfied) {
    return Row(
      children: [
        Icon(
          isSatisfied ? Icons.check_circle : Icons.circle_outlined,
          color: isSatisfied ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isSatisfied ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
