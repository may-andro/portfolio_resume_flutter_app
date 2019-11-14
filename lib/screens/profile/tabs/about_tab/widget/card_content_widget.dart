import 'package:flutter/material.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_header_widget.dart';

class CardContent extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Widget childWidget;

  const CardContent({
    @required this.iconData,
    @required this.label,
    @required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CardHeader(
          iconData: iconData,
          label: label,
        ),
        Divider(color: Colors.grey,),
        childWidget,
      ],
    );
  }
}
