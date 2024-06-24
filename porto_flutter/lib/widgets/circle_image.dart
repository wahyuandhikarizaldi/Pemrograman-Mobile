import 'package:flutter/material.dart';

class CircleImageView extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final void Function() onPressed;

  const CircleImageView({
    required this.imageUrl,
    this.radius = 50,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(imageUrl),
      ),
    );
  }
}
