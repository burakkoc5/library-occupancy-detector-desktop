import 'package:flutter/material.dart';
import 'package:lod_gui/common/colors.dart';

class CustomTextField extends StatefulWidget {
  final bool? isObscure;
  final Function? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final String hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? trailing;
  final TextEditingController controller;
  final FormFieldValidator? validator;
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.isObscure,
      required this.validator,
      this.onTap,
      this.focusNode,
      this.labelText,
      this.icon,
      this.trailing,
      this.onChanged,
      required this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    _isPasswordVisible = widget.isObscure ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: size.width * 0.9 - 28,
      height: 55,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextFormField(
          obscureText: _isPasswordVisible,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            icon: Icon(widget.icon),
            suffixIcon: widget.trailing != null
                ? IconButton(
                    icon: _isPasswordVisible
                        ? widget.trailing!
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
            labelText: widget.labelText,
            border: InputBorder.none,
            //contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}
