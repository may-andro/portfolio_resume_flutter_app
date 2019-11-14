import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool isClickable;

  RoundedButton({@required this.onPressed, @required this.text, this.isClickable = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: MediaQuery.of(context).size.shortestSide * 0.25),
      child: Container(
        height: MediaQuery.of(context).size.shortestSide * 0.125,
        width: double.infinity,
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.shortestSide * 0.15)),
          padding: EdgeInsets.all(8.0),
          color: isClickable ? Colors.blue : Colors.white54,
          child: Text(text,
              style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.shortestSide * 0.04)),
          onPressed: isClickable ? onPressed : (){},
        ),
      ),
    );
  }
}
