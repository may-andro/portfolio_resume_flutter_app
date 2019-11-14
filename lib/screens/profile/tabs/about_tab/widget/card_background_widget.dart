import 'package:flutter/material.dart';

class CardBackground extends StatelessWidget {
  final IconData iconData;

  const CardBackground({@required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Icon(
        iconData,
        size: 100,
        color: Colors.black.withOpacity(0.1),
      ),
    );
  }
}
