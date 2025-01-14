import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final Widget child;
  const Background(
      {super.key,
      required this.image,
      this.height = 0.7,
      this.width = 300,
      required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                height: size.height * height,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 1,
                        color: Colors.grey,
                      ),
                    ]),
                child: child,
              ),
              Image.asset(
                'assets/images/$image',
                width: size.width - width - 28 > width
                    ? width
                    : size.width - width - 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
