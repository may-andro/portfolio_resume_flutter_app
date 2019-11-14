import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset('assets/no_internet.png'),
        ),
        Positioned(
          left: 36,
          right: 36,
          top: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: <Widget>[
              Text(
                'No internet connection found',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Please check your internet connectivity. No internet is detected and everything is on cloud :| ',
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
