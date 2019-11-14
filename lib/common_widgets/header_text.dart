import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String label;

  HeaderText(this.label);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 36,
      left: 0,
      right: 0,
      child: Container(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
