import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final String label;
  final IconData iconData;

  const CardHeader({
    @required this.label,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline.copyWith(color: Colors.black),
        ),
        Icon(iconData),
      ],
    );
  }
}
