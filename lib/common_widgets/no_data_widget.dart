import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset('assets/fetching.gif'),
        ),
        Positioned(
          left: 36,
          right: 36,
          top: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: <Widget>[
              Text(
                'Fetching Data',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Please wait while we fetch the data from cloud.',
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
